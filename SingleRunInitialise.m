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
