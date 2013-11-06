function    [ct,ref_time,fs,fn,recdir] = d3getcues(recdir,prefix,suffix)
%
%    [ct,ref_time,fs,fn,recdir] = d3getcues(recdir,prefix,suffix)
%

ct = [] ; fs = [] ; fn = [] ;

if nargin<2,
   help d3getcues
   return
end

if nargin<3 || isempty(suffix),
   suffix = 'wav' ;
end

if ~isempty(recdir) && ~ismember(recdir(end),'/\'),
   recdir(end+1) = '\' ;
end

recdir(recdir=='/') = '\' ;

cuefname = [recdir prefix suffix 'cues.mat'] ;
if ~exist(cuefname,'file')
   cuefname = makecuefile(recdir,prefix,suffix) ;
end

if isempty(cuefname),
   fprintf(' Unable to make cue file\n') ;
   return
end

C = load(cuefname) ;
fs = C.fs ;
ct = C.cuetab ;
fn = C.fn ;
ref_time = C.ref_time ;
return
