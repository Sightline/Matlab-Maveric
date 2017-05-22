%SINGLERUN This method computes a single run of the scene
%   The SINGLERUN method contains the...
%
%-------------------------------------------------------------------------%
%
%  Author: David Anderson
%  Version: 001
%  Date: 31/1/2014
%
%-------------------------------------------------------------------------%
%
%% Verify Vignette
% perform verification tasks to ensure that the scene and vignette are
% feasible and reasonable (should be at least 1 agent, termination criteria
% should be valid etc.)


%% Reset SimObjects
% All of the simulation objects in the current scene need to be reset to
% their initial conditions.

% For all SimObjects in theSIM.m_hScene.m_hBB
% theSIM.m_hScene = theSIM.m_hScene.ResetSimObjectContext();
% end
clc;
this = theSIM;
%% Single-Run Simulation Loop
bckgnd = (1/256)*[10 70 130];
% Reset the global clock
globalTime = 0.0;
irun = 1;
set(this.m_hGUI.handles.GlobalTimeEdit,'String',num2str(globalTime));
skip = str2double(get(this.m_hGUI.handles.GlobalTimeUpdateEdit,'String'));
% Calculate the global timestep.
dt = this.m_hScene.m_hBB.GetGlobalDT();
% Reset the clocks in the agents
this.m_hScene.m_hBB.ResetClocks(globalTime,dt);
% ...and clear the datacubes/fire the entry conditions.
for ai = 1:this.m_hScene.m_hBB.m_NumAgents
    parent = this.m_hScene.m_hBB.m_AgentList{ai}.m_hDataBus.m_hParent;
    if(isempty(parent))
        this.CallReset(this.m_hScene.m_hBB.m_AgentList{ai})
    end
end
% Re-draw the scene
this.m_hGUI.UpdateGUI();
% Get the termination condition defined in the vignette
terminationCondition = this.m_hScene.m_hTC;
% Check that the termination condition is valid
try
    [~] = eval(terminationCondition);
catch exception
    error('The termination condition is not valid');
end
%
% Clear the data in the existing datacube
this.m_hScene.m_DataCube = [];
% RUN the Single-Run Simulation
tic
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
    %
    this.m_hScene.m_hBB.UpdateEAM();
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
%
% Serialise data to datacube object.
%
kk = 1;
for ii = 1:this.m_hScene.m_hBB.m_NumAgents
    if(strcmp(this.m_hScene.m_hBB.m_AgentList{ii}...
            .m_hDataBus.m_AgentType,'Platform'))
        this.m_hScene.m_DataCube{irun,kk,1} = this.m_hScene.m_hBB...
            .m_AgentList{ii}.m_hDataBus.DynStatesTraj;
        this.m_hScene.m_DataCube{irun,kk,2} = ii;
        this.m_hScene.m_DataCube{irun,kk,3} = this.m_hScene.m_hBB...
            .m_AgentList{ii}.m_hDataBus.DynConTraj;
        this.m_hScene.m_DataCube{irun,kk,4} = this.m_hScene.m_hBB...
            .m_AgentList{ii}.m_hDataBus.GuidanceTraj;
        kk = kk+1;
    end
end
toc
