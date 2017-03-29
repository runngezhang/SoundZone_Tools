function [ magSpect_oct, freqVec_oct ] = octaveBandMean( magSpect, freqVec, octSpace, centerFreq )
%OCTAVEBANDMEAN Given a magnitude spectrum this function will calculate the average (single, third, nth) octave band magnitude
% 
% Syntax:	[ MAGSPECT_OCT, FREQVEC_OCT ] = OCTAVEBANDMEAN( MAGSPECT, FREQVEC, OCTSPACE, CENTERFREQ )
% 
% Inputs: 
% 	magSpect - An arbitrary magnitude spectrum as a vector
% 	freqVec - The corresponding frequencies for each magnitude value
% 	octSpace - A single value between 0 and 1 specifying the octave spacing
%   centerFreq - The center frequency for the octave band
% 
% Outputs: 
% 	magSpect_oct - The magnitude spectrum averaged per octave band
% 	freqVec_oct - The corresponding frequencies for the output magnitude vector
% 
% See also: 

% Author: Jacob Donley
% University of Wollongong
% Email: jrd089@uowmail.edu.au
% Copyright: Jacob Donley 2016
% Date: 8 July 2016
% Revision: 0.1
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 4
    centerFreq=1e3;
end
if nargin < 3
    octSpace = 1/3;
end

if size(magSpect,2) > size(magSpect,1), magSpect = magSpect.'; end
if size(freqVec,2) > size(freqVec,1), freqVec = freqVec.'; end

freqVec_ = nonzeros(freqVec); %remove zero values

n = floor(log(freqVec_( 1 )/centerFreq)/log(2)/octSpace): ...
    floor(log(freqVec_(end)/centerFreq)/log(2)/octSpace);

freqVec_oct = centerFreq * (2 .^ (n*octSpace));
fd = 2^(octSpace/2);
fupper = freqVec_oct * fd;
flower = freqVec_oct / fd;

octBands = [flower' fupper'];

[~, oBandInds] = min(abs( ...
    repmat(freqVec,1,2,length(octBands)) ...
    - repmat(permute(octBands,[3 2 1]),length(freqVec),1,1)  ));

oBandInds = permute(oBandInds, [3 2 1]);

magSpect_oct = zeros(1,length(n));
for band = 1:length(n)
    magSpect_oct(band+1) = mean(  ...
        magSpect( oBandInds(band,1):oBandInds(band,2) ) );
end

magSpect_oct(1) = magSpect(1);
freqVec_oct  = [0 freqVec_oct];
end

