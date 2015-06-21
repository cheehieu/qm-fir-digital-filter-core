function ResetFunction 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: ResetFunction.m
%
% $Rev: 4 $
% $Author: dbekker $
%
%
% Function to reset, sync, zero the DSP FPGA through serial connection
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Reset, sync, and zero the FPGA');
s = serial('COM1','BAUD',115200,'DataBits',8,'Parity','None','FlowControl','None','StopBits',1,'ByteOrder','bigEndian','InputBufferSize',1000,'OutputBufferSize',1000,'Terminator',126);
fopen(s);
fprintf(s,'%s','1');
fclose(s);
delete(s);
end