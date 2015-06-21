function qmfir_udp_demo(compare, gennew, freqNplot, repeat, pnt, skip, host, port, remote, remoteport )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: qmfir_udp_demo.m
%
% $Rev: 4 $
% $Author: dbekker $
% $Date: 2008-10-23 09:59:29 -0700 (Thu, 23 Oct 2008) $
%
% This is a UDP send demonstration, based on TCP/UDP/IP Toolbox 2.0.6
% from Peter Rydesäter. Available here:
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=345&objectType=file
%
% This demo is tailored to the qmfir application (ISAAC NEWTON). 
%
% Usage: qmfir_udp_demo(pnt, skip, host, port, in_file );
%     > compare  - if 0, generate an error from Kayla function, if 1,
%     generate functional error from Charles' algorithm
%     > gennew   - if 0, generate a new data set, if 1 keep last data set
%     > freqNplot- if 0, generate the freqency plot, if 1 do not
%     > repeat   - numbers of times to repeat the rotation
%     > pnt      - numbers of times to rotate the input data
%     > skip     - numbers of points to skip in rotation
%     > remotehost- remote host IP
%     > remoteport- remote host port
%     > host     - host IP
%     > hostport - host port
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lengthdraw = 600;  % Length of gui (change to change position of printed time)

% QANTIZATION ERROR
if compare == 0
    m=1;
    n=0;
    while m<=repeat; %round((n+skip)/skip) <= repeat

        % Clear previous outputs
        hdisp0 = uicontrol('Style','text','BackgroundColor',[1,0.75,1],'Position',[0,lengthdraw-280,125,240]);
        set([hdisp0],'Units','normalized');
        drawnow;
        hdisp0a = uicontrol('Style','text','String','Time ','ForegroundColor','b','FontWeight','b',...
            'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw+40-60,50,15]);
        hdisp0b = uicontrol('Style','text','String',m,'ForegroundColor','b','FontWeight','b',...
            'BackgroundColor',[1,0.75,1],'Position',[55,lengthdraw+40-60,50,15]);
        set([hdisp0a,hdisp0b],'Units','normalized');
        drawnow;

        % Generate New Data from Matlab Program
        if gennew == 0 & n+skip < 14000
            disp('Creating new data from Matlab Algorithm');

            hdisp1 = uicontrol('Style','text','String','Step 1a:',...
                'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
            set([hdisp1],'Units','normalized');
            drawnow;
            tic
            [xpulse,xiqm1, xiqm2, xiqm3] = ssi_ms4_K(n+skip);
            time1 = toc;

            htime1 = uicontrol('Style','text','String', num2str(time1),...
                'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
            set([htime1],'Units','normalized');
            drawnow;

            disp('Preparing data to hex to be send to board');
            hdisp2 = uicontrol('Style','text','String','Step 1b:',...
                'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-80,55,15]);
            set([hdisp2],'Units','normalized');
            drawnow;
            tic
            de2bi_16('signal.txt', 'signal_bi.txt');
            bi2hex('signal_bi.txt', 'signal_hex.txt');
            in_file = ('signal_hex.txt');
            input = load('signal.txt');
            time1 = toc;
            htime2= uicontrol('Style','text','String', num2str(time1),...
                'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-80,60,15]);
            set([htime2],'Units','normalized');
            drawnow;

            % Load Previously Generated Data
        else
            disp('Not creating new data, using previously generated data');
            if m == 1
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_3100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_3100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_3100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_3100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_3100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_3100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_3100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_3100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 2
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_3600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_3600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_3600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_3600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_3600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_3600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_3600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_3600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 3
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_4100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_4100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_4100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_4100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_4100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_4100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_4100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_4100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 4
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_4600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_4600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_4600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_4600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_4600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_4600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_4600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_4600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 5
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_5100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_5100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_5100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_5100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_5100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_5100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_5100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_5100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 6
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_5600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_5600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_5600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_5600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_5600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_5600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_5600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_5600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 7
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,15,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_6100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_6100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_6100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_6100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_6100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_6100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_6100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_6100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 8
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_6600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_6600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_6600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_6600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_6600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_6600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_6600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_6600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 9
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_7100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_7100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_7100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_7100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_7100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_7100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_7100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_7100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 10
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_7600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_7600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_7600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_7600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_7600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_7600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_7600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_7600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 11
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_8100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_8100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_8100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_8100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_8100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_8100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_8100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_8100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 12
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_8600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_8600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_8600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_8600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_8600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_8600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_8600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_8600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 13
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_9100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_9100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_9100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_9100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_9100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_9100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_9100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_9100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 14
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_9600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_9600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_9600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_9600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_9600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_9600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_9600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_9600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 15
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_10100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_10100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_10100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_10100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_10100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_10100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_10100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_10100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 16
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_10600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_10600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_10600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_10600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_10600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_10600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_10600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_10600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 17
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_11100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_11100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_11100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_11100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_11100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_11100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_11100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_11100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 18
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_11600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_11600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_11600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_11600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_11600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_11600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_11600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_11600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 19
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_12100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_12100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_12100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_12100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_12100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_12100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_12100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_12100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 20
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_12600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_12600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_12600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_12600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_12600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_12600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_12600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_12600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 21
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_13100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_13100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_13100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_13100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_13100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_13100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_13100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_13100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 22
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_13600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_13600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_13600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_13600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_13600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_13600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_13600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_13600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            else
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_hex_14100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1r_14100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3r_14100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2r_14100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm1i_14100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm3i_14100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/xiqm2i_14100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles/signal_14100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            end
        end


        fprintf('\nSending data to board, time %d\n', m);
        hdisp4 = uicontrol('Style','text','String','Step 2:',...
            'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-100,55,15]);
        set([hdisp4],'Units','normalized');
        drawnow;
        tic

        % %%%%%%%%%%%%%%%%%%%%%%%%
        % SENDING DATA TO BOARD %%
        % %%%%%%%%%%%%%%%%%%%%%%%%

        % open host UDP socket
        udp=pnet('udpsocket',port);

        if udp~=-1
            % failsafe
            try
                % open input file, read hex data, and get length
                fid = fopen( in_file, 'r' );
                file_data = cast( fscanf( fid, '%x' ), 'int32' );
                len = length(file_data);
                if len < 18000  
                    file_data(len+1:18000,1) = 0;
                end
                len = length(file_data);

                if( mod( len, 50 ) ~= 0 )
                    disp( 'ERROR: number of elements in file must be multiples of 50' );

                else

                    % keep sending data in chunks of 300 points, util <300 are left
                    start_idx = 1;
                    while( len > 0 )
                        if( len >= 300 )
                            end_idx = start_idx + 299;
                            len = len - 300;
                        else
                            end_idx = start_idx + len - 1;
                            len = 0;
                        end

                        % write to write buffer and send buffer as UDP packet
                        pnet(udp,'write',file_data(start_idx:end_idx));
                        pnet(udp,'writepacket',remote,remoteport);
                        % the start index is one past the end index
                        start_idx = end_idx+1;

                        % small delay to get rate down to ~50 Mbps
                        %pause(0.0000001);
                        pause(.01);
                    end
                end

                [y, Fs, nbits, opts] = wavread('notify.wav');
                sound(y,Fs)

                time1 = toc;
                htime4= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-100,60,15]);
                set([htime4],'Units','normalized');
                drawnow;

                hdisp5 = uicontrol('Style','text','String','Step 3:','ForegroundColor','r','FontWeight','b',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-120,55,15]);
                set([hdisp5],'Units','normalized');
                drawnow;
                disp('Data Processing on Board.  Note that this includes the data transfer overhead.');
                tic


                % %%%%%%%%%%%%%%%%%%%%%
                % READING FROM BOARD %%
                % %%%%%%%%%%%%%%%%%%%%%

                %wait/read udp packet to read buffer
                for i = 1:3
                    len=pnet(udp,'readpacket');               
                    
                    if len > 0,
                        if i == 1
                            time1 = toc;
                            htime5= uicontrol('Style','text','String', num2str(time1),'ForegroundColor','r','FontWeight','b',...
                                'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-120,60,15]);
                            set([htime5],'Units','normalized');
                            drawnow;
                            tic

                        end

                        % if packet larger then 1 byte then read maximum of 1000 ints in
                        % network byte order
                        if i == 1
                            data1=pnet(udp,'read',360,'int32');
                            disp('Received packet 1');
                        elseif i == 2
                            data2=pnet(udp,'read',360,'int32');
                            disp('Received packet 2');
                        else
                            data3=pnet(udp,'read',360,'int32');
                            disp('Received packet 3');
                        end
                    else
                        disp('Data%d received Failed', i);
                    end
                end

                time1 = toc;
                hdisp6 = uicontrol('Style','text','String','Step 4:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-140,55,15]);
                set([hdisp6],'Units','normalized');
                drawnow;
                htime6= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-140,60,15]);
                set([htime6],'Units','normalized');
                drawnow;


                [y, Fs, nbits, opts] = wavread('ding.wav');
                sound(y,Fs)

                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Converting Data to Floating Point %%
                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                disp('Converting Data to floating point');
                hdisp7 = uicontrol('Style','text','String','Step 5:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-160,55,15]);
                set([hdisp7],'Units','normalized');
                drawnow;
                tic

                %Convert to correct data1
                de2bi_decimal(data1', 'realimag1.txt');
                data1_new = load('realimag1.txt');
                real1 = data1_new(:,17:32);
                imag1 = data1_new(:,1:16);
                bi2de_decimal(real1,'real1.txt');
                bi2de_decimal(imag1,'imag1.txt');
                real1_de = load('real1.txt');
                imag1_de = load('imag1.txt');

                %Convert to correct data2
                de2bi_decimal(data2', 'realimag2.txt');
                data2_new = load('realimag2.txt');
                real2 = data2_new(:,17:32);
                imag2 = data2_new(:,1:16);
                bi2de_decimal(real2,'real2.txt');
                bi2de_decimal(imag2,'imag2.txt');
                real2_de = load('real2.txt');
                imag2_de = load('imag2.txt');

                %Convert to correct data3
                de2bi_decimal(data3', 'realimag3.txt');
                data3_new = load('realimag3.txt');
                real3 = data3_new(:,17:32);
                imag3 = data3_new(:,1:16);
                bi2de_decimal(real3,'real3.txt');
                bi2de_decimal(imag3,'imag3.txt');
                real3_de = load('real3.txt');
                imag3_de = load('imag3.txt');
                time1 = toc;
                htime7= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-160,60,15]);
                set([htime7],'Units','normalized');
                drawnow;

                if gennew == 0
                    xiqm1r = real(xiqm1)'/sqrt(2);
                    xiqm1i = imag(xiqm1)'/sqrt(2);
                    xiqm2r = real(xiqm2)'/sqrt(2);
                    xiqm2i = imag(xiqm2)'/sqrt(2);
                    xiqm3r = real(xiqm3)'/sqrt(2);
                    xiqm3i = imag(xiqm3)'/sqrt(2);
                end


                % %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Plotting Data and Error %%
                % %%%%%%%%%%%%%%%%%%%%%%%%%%

                %Plotting Data send to board
                subplot(5,1,1)
                plot(input), title('DATA SENT TO BOARD'), ylabel('AMPLITUDE');
                drawnow;

                if freqNplot == 0
                    disp('Producing plots');
                    hdisp8 = uicontrol('Style','text','String','Step 6:',...
                        'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-180,55,15]);
                    set([hdisp8],'Units','normalized');
                    drawnow;
                    tic

                    %Plotting channel 1
                    subplot(5,3,4)
                    plot(xiqm1r(1:359));
                    hold on;
                    plot(real1_de(2:360),'r');
                    grid on
                    title('BAND 1 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,7)
                    plot(xiqm1i(1:359));
                    hold on;
                    plot(-imag1_de(2:360),'r');
                    grid on
                    title('BAND 1 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,10)
                    plot(xiqm1r(1:359) - real1_de(2:360));
                    title('ERROR BAND 1 REAL');
                    grid on;
                    drawnow;
                    subplot(5,3,13)
                    plot(xiqm1i(1:359) + imag1_de(2:360));
                    title('ERROR BAND 1 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 2
                    subplot(5,3,5)
                    plot(xiqm2r(1:359));
                    hold on;
                    plot(real2_de(2:360),'r');
                    grid on
                    title('BAND 2 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,8)
                    plot(xiqm2i(1:359));
                    hold on;
                    plot(-imag2_de(2:360),'r');
                    grid on;
                    title('BAND 2 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,11)
                    plot(xiqm2r(1:359) - real2_de(2:360));
                    title('ERROR BAND 2 REAL');
                    grid on;
                    drawnow;
                    subplot(5,3,14)
                    plot(xiqm2i(1:359) + imag2_de(2:360));
                    title('ERROR BAND 2 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 3
                    subplot(5,3,6)
                    plot(xiqm3r(1:359));
                    hold on;
                    plot(real3_de(2:360),'r');
                    grid on
                    title('NOISE REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,9)
                    plot(xiqm3i(1:359));
                    hold on;
                    plot(-imag3_de(2:360),'r');
                    grid on
                    title('NOISE IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;
                    time1 = toc;
                    htime8= uicontrol('Style','text','String', num2str(time1),...
                        'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-180,60,15]);
                    set([htime8],'Units','normalized');
                    drawnow;

                    disp('Plotting pulse compression');
                    hdisp9 = uicontrol('Style','text','String','Step 7:',...
                        'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-200,55,15]);
                    set([hdisp9],'Units','normalized');
                    drawnow;
                    tic
                    ssi_ms4_afterHardware(n+skip);
                    time1 = toc;
                    htime9= uicontrol('Style','text','String', num2str(time1),...
                        'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-200,60,15]);
                    set([htime9],'Units','normalized');
                    drawnow;

                else
                    disp('Producing plots');
                    hdisp8 = uicontrol('Style','text','String','Step 6:',...
                        'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-180,55,15]);
                    set([hdisp8],'Units','normalized');
                    drawnow;
                    tic

                    %Plotting Data send to board
                    subplot(5,1,1)
                    plot(input), title('DATA SENT TO BOARD'), ylabel('AMPLITUDE');
                    drawnow;

                    %Plotting channel 1
                    subplot(5,3,4)
                    plot(xiqm1r(1:359));
                    hold on;
                    plot(real1_de(2:360),'r');
                    grid on
                    title('BAND 1 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,7)
                    plot(xiqm1i(1:359));
                    hold on;
                    plot(-imag1_de(2:360),'r');
                    grid on
                    title('BAND 1 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,2,7)
                    plot(xiqm1r(1:359) - real1_de(2:360));
                    title('ERROR BAND 1 REAL');
                    grid on;
                    drawnow;
                    subplot(5,2,9)
                    plot(xiqm1i(1:359) + imag1_de(2:360));
                    title('ERROR BAND 1 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 2
                    subplot(5,3,5)
                    plot(xiqm2r(1:359));
                    hold on;
                    plot(real2_de(2:360),'r');
                    grid on
                    title('BAND 2 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,8)
                    plot(xiqm2i(1:359));
                    hold on;
                    plot(-imag2_de(2:360),'r');
                    grid on;
                    title('BAND 2 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,2,8)
                    plot(xiqm2r(1:359) - real2_de(2:360));
                    title('ERROR BAND 2 REAL');
                    grid on;
                    drawnow;
                    subplot(5,2,10)
                    plot(xiqm2i(1:359) + imag2_de(2:360));
                    title('ERROR BAND 2 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 3
                    subplot(5,3,6)
                    plot(xiqm3r(1:359));
                    hold on;
                    plot(real3_de(2:360),'r');
                    grid on
                    title('NOISE REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,9)
                    plot(xiqm3i(1:359));
                    hold on;
                    plot(-imag3_de(2:360),'r');
                    grid on
                    title('NOISE IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;
                    time1 = toc;
                    htime8= uicontrol('Style','text','String', num2str(time1),...
                        'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-180,60,15]);
                    set([htime8],'Units','normalized');
                    drawnow;
                end
            end
        end
        n = n + pnt;
        m = m + 1;
    end

    pnet(udp,'close');

    hdisp10 = uicontrol('Style','text','String','DONE!!',...
        'BackgroundColor',[1,0.75,1],'Position',[10,lengthdraw-240,100,15]);
    set([hdisp10],'Units','normalized');
    drawnow;

    fprintf('\n\nDONE!\n\n');
    [y, Fs, nbits, opts] = wavread('applause.wav');
    sound(y,Fs)





    % FUNCTIONAL ERROR
else
    m=1;
    n=0;
    while m <= repeat

        % Clear previous outputs
        hdisp0 = uicontrol('Style','text','BackgroundColor',[1,0.75,1],'Position',[0,lengthdraw-280,125,240]);
        set([hdisp0],'Units','normalized');
        drawnow;
        hdisp0a = uicontrol('Style','text','String','Time ','ForegroundColor','b','FontWeight','b',...
            'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw+40-60,50,15]);
        hdisp0b = uicontrol('Style','text','String',m,'ForegroundColor','b','FontWeight','b',...
            'BackgroundColor',[1,0.75,1],'Position',[55,lengthdraw+40-60,50,15]);
        set([hdisp0a,hdisp0b],'Units','normalized');
        drawnow;

        % Generate New Data from Matlab Program
        if gennew == 0 & n+skip < 14000
            disp('Creating new data from Matlab Algorithm');
            hdisp1 = uicontrol('Style','text','String','Step 1a:',...
                'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
            set([hdisp1],'Units','normalized');
            drawnow;
            tic
            [xpulse,xiqm1, xiqm2, xiqm3] = ssi_ms4(n+skip);
            time1 = toc;

            htime1 = uicontrol('Style','text','String', num2str(time1),...
                'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
            set([htime1],'Units','normalized');
            drawnow;

            disp('Preparing data to hex to be send to board');
            hdisp2 = uicontrol('Style','text','String','Step 1b:',...
                'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-80,55,15]);
            set([hdisp2],'Units','normalized');
            drawnow;
            tic
            de2bi_16('signal.txt', 'signal_bi.txt');
            bi2hex('signal_bi.txt', 'signal_hex.txt');
            in_file = ('signal_hex.txt');
            input = load('signal.txt');
            time1 = toc;
            htime2= uicontrol('Style','text','String', num2str(time1),...
                'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-80,60,15]);
            set([htime2],'Units','normalized');
            drawnow;

            % Load Previously Generated Data
        else
            disp('Not creating new data, using previously generated data');
            if m == 1
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_3100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_3100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_3100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_3100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_3100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_3100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_3100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_3100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 2
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_3600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_3600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_3600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_3600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_3600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_3600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_3600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_3600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 3
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_4100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_4100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_4100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_4100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_4100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_4100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_4100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_4100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 4
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_4600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_4600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_4600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_4600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_4600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_4600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_4600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_4600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 5
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_5100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_5100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_5100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_5100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_5100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_5100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_5100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_5100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 6
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_5600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_5600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_5600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_5600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_5600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_5600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_5600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_5600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 7
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_6100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_6100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_6100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_6100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_6100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_6100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_6100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_6100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 8
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_6600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_6600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_6600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_6600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_6600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_6600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_6600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_6600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 9
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_7100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_7100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_7100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_7100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_7100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_7100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_7100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_7100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 10
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_7600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_7600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_7600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_7600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_7600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_7600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_7600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_7600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 11
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_8100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_8100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_8100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_8100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_8100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_8100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_8100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_8100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 12
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_8600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_8600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_8600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_8600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_8600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_8600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_8600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_8600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 13
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_9100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_9100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_9100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_9100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_9100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_9100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_9100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_9100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 14
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_9600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_9600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_9600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_9600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_9600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_9600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_9600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_9600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 15
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_10100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_10100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_10100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_10100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_10100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_10100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_10100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_10100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 16
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_10600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_10600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_10600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_10600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_10600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_10600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_10600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_10600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 17
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_11100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_11100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_11100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_11100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_11100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_11100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_11100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_11100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 18
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_11600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_11600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_11600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_11600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_11600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_11600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_11600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_11600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 19
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_12100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_12100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_12100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_12100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_12100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_12100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_12100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_12100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 20
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_12600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_12600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_12600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_12600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_12600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_12600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_12600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_12600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 21
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_13100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_13100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_13100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_13100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_13100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_13100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_13100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_13100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            elseif m == 22
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_13600.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_13600.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_13600.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_13600.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_13600.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_13600.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_13600.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_13600.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            else
                disp('Loading previously generated data');
                hdisp3 = uicontrol('Style','text','String','Step 1:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-60,55,15]);
                set([hdisp3],'Units','normalized');
                drawnow;
                tic
                in_file = ('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_hex_14100.txt');
                xiqm1r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1r_14100.txt');
                xiqm3r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3r_14100.txt');
                xiqm2r = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2r_14100.txt');
                xiqm1i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm1i_14100.txt');
                xiqm3i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm3i_14100.txt');
                xiqm2i = load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/xiqm2i_14100.txt');
                %Reading Initial Input
                input=load('/proj/users/hmnguyen/qmfir/qmfir_eth/qmfir_udp/matlab_gui/InputFiles_C/signal_14100.txt');
                time1 = toc;
                htime3= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-60,60,15]);
                set([htime3],'Units','normalized');
                drawnow;
            end
        end

        fprintf('\nSending data to board, time %d\n', m);
        hdisp4 = uicontrol('Style','text','String','Step 2:',...
            'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-100,55,15]);
        set([hdisp4],'Units','normalized');
        drawnow;
        tic

        % %%%%%%%%%%%%%%%%%%%%%%%%
        % SENDING DATA TO BOARD %%
        % %%%%%%%%%%%%%%%%%%%%%%%%

        % open host UDP socket
        udp=pnet('udpsocket',port);


        if udp~=-1
            % failsafe
            try,
                % open input file, read hex data, and get length
                fid = fopen( in_file, 'r' );
                file_data = cast( fscanf( fid, '%x' ), 'int32' );
                len = length( file_data );
                if len < 18000
                    file_data(len+1:18000,1) = 0;
                end
                len = length(file_data);

                if( mod( len, 50 ) ~= 0 )
                    disp( 'ERROR: number of elements in file must be multiples of 50' );

                else

                    % keep sending data in chunks of 300 points, util <300 are left
                    start_idx = 1;
                    while( len > 0 )
                        if( len >= 300 )
                            end_idx = start_idx + 299;
                            len = len - 300;
                        else
                            end_idx = start_idx + len - 1;
                            len = 0;
                        end

                        % write to write buffer and send buffer as UDP packet
                        pnet(udp,'write',file_data(start_idx:end_idx));
                        pnet(udp,'writepacket',remote,remoteport);

                        % the start index is one past the end index
                        start_idx = end_idx+1;

                        % small delay to get rate down to ~50 Mbps
                        %   pause(0.0001);
                        pause(.01);

                    end
                end
                [y, Fs, nbits, opts] = wavread('notify.wav');
                sound(y,Fs)

                time1 = toc;
                htime4= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-100,60,15]);
                set([htime4],'Units','normalized');
                drawnow;

                hdisp5 = uicontrol('Style','text','String','Step 3:','ForegroundColor','r','FontWeight','b',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-120,55,15]);
                set([hdisp5],'Units','normalized');
                drawnow;
                disp('Data Processing on Board.  Note that this includes the data transfer overhead.');
                tic


                % %%%%%%%%%%%%%%%%%%%%%
                % READING FROM BOARD %%
                % %%%%%%%%%%%%%%%%%%%%%             
                %wait/read udp packet to read buffer
                for i = 1:3                    
                    len=pnet(udp,'readpacket');
                    if len > 0,
                        if i == 1
                            time1 = toc;
                            htime5= uicontrol('Style','text','String', num2str(time1),'ForegroundColor','r','FontWeight','b',...
                                'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-120,60,15]);
                            set([htime5],'Units','normalized');
                            drawnow;
                            tic
                        end

                        % if packet larger then 1 byte then read maximum of 1000 ints in
                        % network byte order
                        if i == 1
                            data1=pnet(udp,'read',360,'int32');
                            disp('Received packet 1');
                        elseif i == 2
                            data2=pnet(udp,'read',360,'int32');
                            disp('Received packet 2');
                        else
                            data3=pnet(udp,'read',360,'int32');
                            disp('Received packet 3');
                        end
                    else
                        disp('Data%d received Failed', i);
                    end
                end

                time1 = toc;
                hdisp6 = uicontrol('Style','text','String','Step 4:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-140,55,15]);
                set([hdisp6],'Units','normalized');
                drawnow;
                htime6= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-140,60,15]);
                set([htime6],'Units','normalized');
                drawnow;

                [y, Fs, nbits, opts] = wavread('ding.wav');
                sound(y,Fs)


                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Converting Data to Floating Point %%
                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                disp('Converting Data to floating point');
                hdisp7 = uicontrol('Style','text','String','Step 5:',...
                    'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-160,55,15]);
                set([hdisp7],'Units','normalized');
                drawnow;
                tic

                %Convert to correct data1
                de2bi_decimal(data1', 'realimag1.txt');
                data1_new = load('realimag1.txt');
                real1 = data1_new(:,17:32);
                imag1 = data1_new(:,1:16);
                bi2de_decimal(real1,'real1.txt');
                bi2de_decimal(imag1,'imag1.txt');
                real1_de = load('real1.txt');
                imag1_de = load('imag1.txt');

                %Convert to correct data2
                de2bi_decimal(data2', 'realimag2.txt');
                data2_new = load('realimag2.txt');
                real2 = data2_new(:,17:32);
                imag2 = data2_new(:,1:16);
                bi2de_decimal(real2,'real2.txt');
                bi2de_decimal(imag2,'imag2.txt');
                real2_de = load('real2.txt');
                imag2_de = load('imag2.txt');

                %Convert to correct data3
                de2bi_decimal(data3', 'realimag3.txt');
                data3_new = load('realimag3.txt');
                real3 = data3_new(:,17:32);
                imag3 = data3_new(:,1:16);
                bi2de_decimal(real3,'real3.txt');
                bi2de_decimal(imag3,'imag3.txt');
                real3_de = load('real3.txt');
                imag3_de = load('imag3.txt');
                time1 = toc;
                htime7= uicontrol('Style','text','String', num2str(time1),...
                    'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-160,60,15]);
                set([htime7],'Units','normalized');
                drawnow;

                if gennew == 0
                    xiqm1r = real(xiqm1)'/sqrt(2);
                    xiqm1i = imag(xiqm1)'/sqrt(2);
                    xiqm2r = real(xiqm2)'/sqrt(2);
                    xiqm2i = imag(xiqm2)'/sqrt(2);
                    xiqm3r = real(xiqm3)'/sqrt(2);
                    xiqm3i = imag(xiqm3)'/sqrt(2);
                end


                % %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Plotting Data and Error %%
                % %%%%%%%%%%%%%%%%%%%%%%%%%%

                %Plotting Data send to board
                subplot(5,1,1)
                plot(input), title('DATA SENT TO BOARD'), ylabel('AMPLITUDE');
                drawnow;

                if freqNplot == 0
                    disp('Producing plots');
                    hdisp8 = uicontrol('Style','text','String','Step 6:',...
                        'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-180,55,15]);
                    set([hdisp8],'Units','normalized');
                    drawnow;
                    tic

                    %Plotting channel 1
                    subplot(5,3,4)
                    plot(xiqm1r);
                    hold on;
                    plot(real1_de(14:359),'r');
                    grid on
                    title('BAND 1 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,7)
                    plot(xiqm1i);
                    hold on;
                    plot(-imag1_de(14:359),'r');
                    grid on
                    title('BAND 1 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,10)
                    plot(xiqm1r - real1_de(14:359));
                    title('ERROR BAND 1 REAL');
                    grid on;
                    drawnow;
                    subplot(5,3,13)
                    plot(xiqm1i + imag1_de(14:359));
                    title('ERROR BAND 1 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 2
                    subplot(5,3,5)
                    plot(xiqm2r);
                    hold on;
                    plot(real2_de(14:359),'r');
                    grid on
                    title('BAND 2 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,8)
                    plot(xiqm2i);
                    hold on;
                    plot(-imag2_de(14:359),'r');
                    grid on
                    title('BAND 2 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,11)
                    plot(xiqm2r - real2_de(14:359));
                    title('ERROR BAND 2 REAL');
                    grid on;
                    drawnow;
                    subplot(5,3,14)
                    plot(xiqm2i + imag2_de(14:359));
                    title('ERROR BAND 2 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 3
                    subplot(5,3,6)
                    plot(xiqm3r);
                    hold on;
                    plot(real3_de(14:359),'r');
                    grid on
                    title('NOISE REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,9)
                    plot(xiqm3i);
                    hold on;
                    plot(-imag3_de(14:359),'r');
                    grid on
                    title('NOISE IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;
                    time1 = toc;
                    htime8= uicontrol('Style','text','String', num2str(time1),...
                        'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-180,60,15]);
                    set([htime8],'Units','normalized');
                    drawnow;

                    disp('Plotting pulse compression');
                    hdisp9 = uicontrol('Style','text','String','Step 7:',...
                        'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-200,55,15]);
                    set([hdisp9],'Units','normalized');
                    drawnow;
                    tic
                    ssi_ms4_afterHardware(n+skip);
                    time1 = toc;
                    htime9= uicontrol('Style','text','String', num2str(time1),...
                        'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-200,60,15]);
                    set([htime9],'Units','normalized');
                    drawnow;

                else
                    disp('Producing plots');
                    hdisp8 = uicontrol('Style','text','String','Step 6:',...
                        'BackgroundColor',[1,0.75,1],'Position',[5,lengthdraw-180,55,15]);
                    set([hdisp8],'Units','normalized');
                    drawnow;
                    tic

                    %Plotting channel 1
                    subplot(5,3,4)
                    plot(xiqm1r);
                    hold on;
                    plot(real1_de(14:359),'r');
                    grid on
                    title('BAND 1 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,7)
                    plot(xiqm1i);
                    hold on;
                    plot(-imag1_de(14:359),'r');
                    grid on
                    title('BAND 1 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,2,7)
                    plot(xiqm1r - real1_de(14:359));
                    title('ERROR BAND 1 REAL');
                    grid on;
                    drawnow;
                    subplot(5,2,9)
                    plot(xiqm1i + imag1_de(14:359));
                    title('ERROR BAND 1 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 2
                    subplot(5,3,5)
                    plot(xiqm2r);
                    hold on;
                    plot(real2_de(14:359),'r');
                    grid on
                    title('BAND 2 REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,8)
                    plot(xiqm2i);
                    hold on;
                    plot(-imag2_de(14:359),'r');
                    grid on
                    title('BAND 2 IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,2,8)
                    plot(xiqm2r - real2_de(14:359));
                    title('ERROR BAND 2 REAL');
                    grid on;
                    drawnow;
                    subplot(5,2,10)
                    plot(xiqm2i + imag2_de(14:359));
                    title('ERROR BAND 2 IMAGINARY');
                    grid on;
                    drawnow;

                    %Plotting channel 3
                    subplot(5,3,6)
                    plot(xiqm3r);
                    hold on;
                    plot(real3_de(14:359),'r');
                    grid on
                    title('NOISE REAL'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;

                    subplot(5,3,9)
                    plot(xiqm3i);
                    hold on;
                    plot(-imag3_de(14:359),'r');
                    grid on
                    title('NOISE IMAGINARY'), ylabel('MAGNITUDE');
                    hold off;
                    drawnow;
                    time1 = toc;
                    htime8= uicontrol('Style','text','String', num2str(time1),...
                        'BackgroundColor',[1,0.75,1],'Position',[60,lengthdraw-180,60,15]);
                    set([htime8],'Units','normalized');
                    drawnow;
                end
            end
        end
        n = n + pnt;
        m = m + 1;
    end

    pnet(udp,'close');

    hdisp10 = uicontrol('Style','text','String','DONE!!',...
        'BackgroundColor',[1,0.75,1],'Position',[10,lengthdraw-240,100,15]);
    set([hdisp10],'Units','normalized');
    drawnow;

    fprintf('\n\nDONE!\n\n');
    [y, Fs, nbits, opts] = wavread('applause.wav');
    sound(y,Fs)


end




end
