%%************************************************************************
%              Modelling of Autonomous Vehicle Environments              *
%                                                                        *
%                   using Robust, Intelligent Computing.                 *
%                                                                        *
%                              (MAVERIC)                                 *
%------------------------------------------------------------------------*
%                                                                        *
% Author: Dr David Anderson                                              *
%                                                                        *
%------------------------------------------------------------------------*
%                                                                        *
% Issue 001 Date: 20/1/2014                                              *
%                                                                        *
%*************************************************************************
%
% Description: TBC
%
%
%% Create the MAVERIC object
clear all; clc; 
close('all','hidden');
%
addpath(genpath('./'));
pause(1);
%
dbstop if error
% dbstop in +MAVERIC_GUI\@MainGUI\UpdateGUI at 21
import MAVERIC_SE.SimEngine.*
try
    theSIM = Simulation.getInstance();
catch exception
    error(exception.identifier,exception.message);
end
%% Launch MAVERIC_GUI
try
    theSIM = theSIM.CreateGUI();
catch exception
    error(exception.identifier,exception.message);
end
% Update the GUI
theSIM.m_hGUI = theSIM.m_hGUI.UpdateGUI();
%% CleanUp and Exit
