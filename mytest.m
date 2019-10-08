% Based on Example 1: Synthesis of a "text" texture image, using
% Portilla-Simoncelli texture analysis/synthesis code, based on
% alternate projections onto statistical constraints in a complex
% overcomplete wavelet representation.
%
% See Readme.txt, and headers of textureAnalysis.m and
% textureSynthesis.m for more details.
%
% Javier Portilla (javier@decsai.ugr.es).  March, 2001

close all
%color = imread('2_hv.jpg');
%gray = rgb2gray(color);
%gray256 = imresize(gray,0.256)
%imwrite(gray256,'.pgm');

im1 = pgmRead('rsz_2_hv.pgm');	% im0 is a double float matrix! pgmRead 
im2 = pgmRead('rsz_58_c.pgm');
% input must be a file name or a file identifier.

Nsc = 4; % Number of scales
Nor = 4; % Number of orientations
Na = 9;  % Spatial neighborhood is Na x Na coefficients
	 % It must be an odd number!

params1 = textureAnalysis(im1, Nsc, Nor, Na);
params2 = textureAnalysis(im2, Nsc, Nor, Na);

meanparams = struct(); % this is the output mean struct
combparams = [params1, params2]; % concatenate into one non-scaler struct
fn = fieldnames(combparams); % this is the cell including all the field names
for i = 1:numel(fn)
    f = fn{i};
    d = numel(size(params1.(f))) + 1;
    meanparams.(f) = mean(cat(d,combparams.(f)), d);   % or weighted average
end

Niter = 10;	% Number of iterations of synthesis loop
Nsx = 256;	% Size of synthetic image is Nsy x Nsx
Nsy = 256;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

res = textureSynthesis(meanparams, [Nsy Nsx], Niter);

close all
figure(1)
subplot(1,2,1); showIm(im1, 'auto', 1, 'Original texture');
subplot(1,2,2); showIm(im2, 'auto', 1, 'Original texture');
figure(2)
showIm(res, 'auto', 1, 'Synthesized texture');