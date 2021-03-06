function    [SL,f] = tagwavSL(tag,cues,nfft,len,freqr,plim)
%
%    [SL,f] = tagwavSL(tag,cues,nfft,len,freqr,plim)
%

SL = [] ; f = [] ;
if nargin<2,
   help tagwavSL ;
   return
end

if nargin<3 || isempty(nfft),
   nfft = 1024 ;
end

if nargin<4 || isempty(len),
   len = 10 ;
end

if nargin<6,
   plim = [] ;
end

cue = cues(1) ;
endcue = cues(2) ;
nov = nfft/2 ;

% get the sampling frequency
[x,fs] = tagwavread(tag,cue,0.1) ;
N = floor((endcue-cue)/len) ;

P = zeros(nfft/2,N) ;
w = hanning(nfft) ;
f = (0:nfft/2-1)/nfft*fs ;
if nargin>=5 & ~isempty(freqr),
   kf = find(f>=freqr(1) & f<freqr(2)) ;
else
   kf = 1:length(f) ;
end

for k=1:N,
   fprintf('Reading at cue %d\n', cue) ;
   x = tagwavread(tag,floor([fs*cue+1 fs*(cue+len)])) ;
   if size(x,2)>1,
      x = x(:,1) ;
   end
   if length(x)<=nfft,
      P = P(:,1:k-1) ;
      break
   end
   cue = cue+len ;
   [x,z] = buffer(x,nfft,nov,'nodelay') ;
   x = detrend(x).*repmat(w,1,size(x,2)) ;
   ff = abs(fft(x)).^2 ;
   if ~isempty(plim),
      p = sum(ff(kf)) ;
      thr = prctile(p,plim) ;
      kp = find(p>thr) ;
      P(:,k) = sum(ff(1:nfft/2,kp),2)/length(kp) ;      
   else   
      P(:,k) = sum(ff(1:nfft/2,:),2)/size(x,2) ;
   end
end

P = P/(nfft^2) ;
slc = 3-10*log10(fs/nfft)-10*log10(sum(w.^2)/nfft) ;
SL = 10*log10(P)+slc ;
return

