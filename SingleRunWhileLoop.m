t = 0;
while(eval(terminationCondition));
    drawnow;
    if(get(this.m_hGUI.handles.StopButton,'UserData')==1)
        set(this.m_hGUI.handles.RunButton,'Background',bckgnd);
        set(this.m_hGUI.handles.StopButton,'UserData',0);
        return;
    end
    if(get(this.m_hGUI.handles.PauseButton,'UserData')==1)
        set(this.m_hGUI.handles.RunButton,'Background',bckgnd);
        this.m_hScene = this.m_hScene.DrawScene_ver2();
        drawnow;
        waitfor(this.m_hGUI.handles.PauseButton,'UserData',0);
        set(this.m_hGUI.handles.RunButton,'Background','r');
    end
    % Each SimObject should only be updated if the global simulation time
    % coincides with the objects internal clock. This allows different
    % objects to operate at different timesteps. The 10usec bound is
    % needed to account for any jitter between the local and global
    % time signals as the simulation progresses.
    %
    %
    %----------------------------------------------------------------------
    % Update the Entity Adjacency Matrix. To ensure the EAM is maintained
    % at all times, this update will be performed every global clock cycle.
    if(abs(globalTime-t)<1e-5)
        this.m_hScene.m_hBB.UpdateEAM();
        t = t+1;
    end
    %
    %----------------------------------------------------------------------
    % Perform collision detection. Again to minimise the possibility of
    % tunneling, collision detection will be checked at every global clock
    % cycle.
    %
    this.m_hScene.m_hBB.Collision();
    %
    %----------------------------------------------------------------------
    % Update the geometry of each entity in the simulation.
    % First the agents
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        % If the object is active and has a Geometry module
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasGeometry)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentGeoMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateGeometry();
                end
            end
        end
    end
    % Now the scenery objects
    for si = 1:this.m_hScene.m_hBB.m_NumSceneryObjects
        if(strcmp(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Geometry module
            if(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus.m_HasGeometry)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus...
                        .m_hCurrentGeoMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_SceneryObjList{si}.UpdateGeometry();
                end
            end
        end
    end
    %
    %----------------------------------------------------------------------
    % Update the detection of each sensor entity in the simulation.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Detection module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasDetection)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentDetectionMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateDetection();
                end
            end
        end
    end
    %
    %----------------------------------------------------------------------
    % Update the tracking of each sensor entity in the simulation.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Tracking module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasTracking)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentTrackingMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateTracking();
                end
            end
        end
    end
    % Now display tracking information in the GUI if required.
    %
    if(abs(mod(globalTime,skip*dt)) < 1e-5 || (abs(mod(globalTime,1)-skip*dt) < 1e-5))
        if(~isempty(this.m_hScene.m_hCurrentVignetteObject))
            this.m_hScene.m_hCurrentVignetteObject.PopulateTrackControls();
        end
    end
    %----------------------------------------------------------------------
    % Update the artificial intelligence module of each agent in the
    % simulation.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has an AI module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasAI)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentAIMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateAI();
                end
            end
        end
    end
    %
    %----------------------------------------------------------------------
    % Update the guidance module of each agent in the simulation.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Guidance module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasGuidance)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentGuidanceMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateGuidance();
                end
            end
        end
    end
    %
    %----------------------------------------------------------------------
    % Update the control of each entity in the simulation.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Control module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasControl)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentControlMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateControl();
                end
            end
        end
    end
    for si = 1:this.m_hScene.m_hBB.m_NumSceneryObjects
        if(strcmp(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Control module
            if(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus.m_HasControl)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus...
                        .m_hCurrentControlMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_SceneryObjList{si}.UpdateControl();
                end
            end
        end
    end
    %
    %----------------------------------------------------------------------
    % Update the dynamics of each dynamic entity in the simulation.
    %
    % First the agents
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has an active Dynamics module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasDynamic)
                % and is a base platform
                parent = this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_hParent;
                if(isempty(parent))
                    % Get the next object in the list
                    if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                            .m_hCurrentDynMRState.m_NextTime-globalTime) < 1e-5)
                        this.m_hScene.m_hBB.m_AgentList{ai}.UpdateDynamics();
                    end
                end
            end
        end
    end
    %
    % The dynamics call need to be re-written in a recursive function to
    % allow for the situation of docked children. Running again is a
    % temporary workaround.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has an active Dynamics module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasDynamic)
                % and is not a base platform
                parent = this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_hParent;
                if(~isempty(parent))
                    % Get the next object in the list
                    if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                            .m_hCurrentDynMRState.m_NextTime-globalTime) < 1e-5)
                        this.m_hScene.m_hBB.m_AgentList{ai}.UpdateDynamics();
                    end
                end
            end
        end
    end
    % Now the scenery objects
    for si = 1:this.m_hScene.m_hBB.m_NumSceneryObjects
        if(strcmp(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has an active Dynamics module
            if(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus.m_HasDynamic)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_SceneryObjList{si}.m_hDataBus...
                        .m_hCurrentDynMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_SceneryObjList{si}.UpdateDynamics();
                end
            end
        end
    end
    %
    %----------------------------------------------------------------------
    % Update the sightline of each sensor entity in the simulation.
    %
    for ai = 1:this.m_hScene.m_hBB.m_NumAgents
        if(strcmp(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_SimStatus,'Active'))
            % If the object has a Sightline module
            if(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_HasSightline)
                % Get the next object in the list
                if(abs(this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus...
                        .m_hCurrentSightlineMRState.m_NextTime-globalTime) < 1e-5)
                    this.m_hScene.m_hBB.m_AgentList{ai}.UpdateSightline();
                end
            end
        end
    end
    %**********************************************************************
    % Update the globalTime
    % First, get the current timestep (may have changed if a MR switch has
    % occured.
    dt = this.m_hScene.m_hBB.GetGlobalDT();
    % Report to the GUI
    if(abs(mod(globalTime,skip*dt)) < 1e-5 || (abs(mod(globalTime,1)-skip*dt) < 1e-5))
        set(this.m_hGUI.handles.GlobalTimeEdit,...
            'String',num2str(globalTime));
        set(this.m_hGUI.handles.GlobalTimeStepEdit,'String',num2str(dt));
        drawnow;
    end
    % Now reset the clocks in all the scene objects
    globalTime = globalTime + dt;
    globalTime = round(globalTime/dt)*dt;
    this.m_hScene.m_hBB.ResetClocks(globalTime,dt);
    
end % Single Run Loop