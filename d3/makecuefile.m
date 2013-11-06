function    cuefname = makecuefile(recdir,prefix,suffix)
%
%    cuefname = makecuefile(recdir,prefix,suffix)
%

if nargin<3 || isempty(suffix),
   suffix = 'wav' ;
end

if ~isempty(recdir) && ~ismember(recdir(end),'/\:') ;
   recdir(end+1) = '/' ;
end

cuefname = [recdir prefix suffix 'cues.mat'] ;

% check for t-type timing files
[cuetab,fn,id] = d3makettab(recdir,prefix,suffix) ;

if isempty(cuetab),
   [cuetab,fn,id] = d3makectab(recdir,prefix,suffix) ;
end

%fname = [recdir fn{cuetab(1,1)} '.' suffix] ;
fname = [recdir fn{1} '.' suffix] ;

if ~exist(fname,'file'),
   fprintf(' No wav file found matching first file name\n') ;
   return
end
[s,fs] = wavread16(fname,'size') ;
fs = fs(1) ;

% nominate a reference time and refer the cues to this time
ref_time = cuetab(1,2) ;
ctimes = (cuetab(:,2)-ref_time)+cuetab(:,3) ; 
cuetab = [cuetab(:,1) ctimes cuetab(:,4)] ;

vv = version ;
if vv(1)>'6',
   save(cuefname,'-v6','ref_time','fn','fs','id','cuetab') ;
else
   save(cuefname,'ref_time','fn','fs','id','cuetab') ;
end

return
