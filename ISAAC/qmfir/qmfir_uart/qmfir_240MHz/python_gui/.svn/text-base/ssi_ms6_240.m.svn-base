%function ssi_ms6_240(rotate)
%SSI	Split Spectrum Implementation - Multi-Stage Decimation Design
%
%	SSI simulates an offset video chirp, designes the bandpass decimation
%	filter, designes the halfband filter, performs the bandpass decimation
%	filtering at the required output format, and pulse-compresses the 
%	decimated output.
%	
%	Only the bandpass decimation filtering portion is required for
%	HW implementation at this time.
%
%	In this first iteration, the decimation factor is assumed to be an integer.
%	However, fractional decimation ratio is a desired feature for future
% 	iteration.
%  

%       Charles Le, 02/15/04.
%	This work was performed at the Jet Propulsion Laboratory, California
%	Institute of Technology, under contract with the National Aeronautics
%	and Space Administration.
%
%	Version 0.1
%
%	FOR OFFICIAL USE only.
%
%	This program was sent to AccelChip for a quick conversion to RTL design,
%	so that the JPL team can evaluate the effectiveness of AccelChip's tools.
%
%  2008/04/02. Modify and send to ISAAC team for FPGA's development and implementation.
%  2008/05/27. Version 2: implement polyphase representation
%  2008/06/17. Version 3: impose HW constraints on filter length
%  2008/07/01. Version 4: simulate radar receive window with multiple targets
%  2008/10/12. Version 4: simulate target positions by shifting simulated return echo.
%  2008/10/14. Version 6: 240 MHz design with all FIR filters for point-target response
  

%clear all;

%disp(' ');
%disp('***** Decimation Filter Design and Simulation for SMAP at 240 MHz *****');

%%%%%%%%%%%%%%%%%
%%% CONSTANTS %%%
%%%%%%%%%%%%%%%%%
rot=rotate;
%f_noi2=f_noi;
%constants;
load mylib;
%f_noi=f_noi2;
rotate=rot;

%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUT PARAMETERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%

%disp(' ');
%disp('--- Read Input Parameters ---');

%ssi_ms6_240_params;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for Target Simulator %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%params_tgtsim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CALCULATED PARAMETERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp(' ');
%disp('--- Calculate Parameters ---');

%ssi_ms6_240_paramcal;



%%%%%%%%%%%%%%%%%%%%%%%%
%%% SIGNAL GENERATION %%%
%%%%%%%%%%%%%%%%%%%%%%%%

%disp(' ');
%disp('--- Generate Signal ---');

ssi_ms6_240_siggen;



%%%%%%%%%%%%%%%%%%%%%
%%% FILTER DESIGN %%%
%%%%%%%%%%%%%%%%%%%%%

%disp(' ');
%disp('--- Design Filter ---');

%ssi_ms6_240_filtdes;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% START THE MULTI-STAGE BASEBANDING AND DECIMATION FILTERING PROCESS %%%
%%% HW Implementation                                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp(' ');
%disp('--- Implement Decimation Filter ---');

ssi_ms6_240_hwimp;


%%% Done BDF Process! %%%


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pulse Compression %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%disp(' ');
%disp('--- Compress Pulse ---');

%ssi_ms6_240_pc;


%%%%%%%%%%%%%%%%
%%% Plotting %%%
%%%%%%%%%%%%%%%%

%disp(' ');
%disp('Plot Signals');

%ssi_ms6_240_plt;


%%%%%%%%%%%%%%
%%% Saving %%%
%%%%%%%%%%%%%%

%disp(' ');
%disp('Done! Isn''t That Fast ...');\
%disp(' ');

return;       % Comment it out to save

ssi_ms6_240_sav;

%end

