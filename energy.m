

%Here we build three energy maps:
% Wavg is an energy map of mean energy values per theta/lambda
% Wmx is an energy map of maximum energy values per theta/lambda
% Wig is an energy map of the (summed) integration value per theta/lambda

pixels = 80;
nOscillations = 8;
theta = 90;
pShift = 0;

%initialize empty energy maps
Wig1 = zeros(pixels);

Wig2 = zeros(pixels);

%Initialize 

randsig = 2 * rand(pixels) - 1;
probe1 = sinwav(pixels,nOscillations,theta,pShift);
probe2 = (probe1 + randsig)/2;

padsize = 2^nextpow2(pixels) - pixels


randsig = padarray(padarray(randsig, padsize, 'post')', padsize,'post');
probe1 = padarray(padarray(probe1, padsize, 'post')', padsize,'post');
probe2 = padarray(padarray(probe2, padsize, 'post')', padsize,'post');
tic
%% The problem: 
for i=1:pixels
    for j=1:pixels
        
      
        thetarange = linspace(theta-30,theta+30,pixels);

        xirange = linspace(1,3,pixels);
        
        std = sinwav(pixels,xirange(j)*4,thetarange(i),pShift);
        
        crr1 = (sqrt( (xcorr2_fft(probe1,cos(std))).^2 + (xcorr2_fft(probe1,sin(std))).^2 ));
        crr2 = (sqrt( (xcorr2_fft(probe2,cos(std))).^2 + (xcorr2_fft(probe2,sin(std))).^2 ));
        
        
        ig1 = integr(crr1);
        ig2 = integr(crr2);
       
        Wig1(i,j) = ig1;
        Wig2(i,j) = ig2;
    end
    i
end
toc


[ssr1,snd1] = max(crr1(:));
[ij1,ji1] = ind2sub(size(crr1),snd1); 
maxstr1 = strcat('Maximum =  ',num2str(ssr1));

subplot(1,2,1)
mesh(Wig1)
colormap jet
title('Integration Energy of Clean Signal')
hold on

XTL = {'\theta = -30','\theta =0','\theta = +30'};
Ticks = [0 30 61];
YTL = {'\xi = 1', '\xi = 2', '\xi = 3'};
set(gca, 'xtick', Ticks)
set(gca, 'xticklabel', XTL)
set(gca, 'ytick', Ticks)
set(gca, 'yticklabel', YTL)


subplot(1,2,2)
mesh(Wig2)
colormap jet
title('Integration Energy of Dirty Signal')
hold on

XTL = {'\theta = -30','\theta =0','\theta = +30'};
Ticks = [0 30 61];
YTL = {'\xi = 1', '\xi = 2', '\xi = 3'};
set(gca, 'xtick', Ticks)
set(gca, 'xticklabel', XTL)
set(gca, 'ytick', Ticks)
set(gca, 'yticklabel', YTL)


