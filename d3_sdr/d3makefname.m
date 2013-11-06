function    fname = d3makefname(tag,type,chip,SILENT)
%
%    fname = makefname(tag,type,[chip,SILENT])
%     Generate a standard filename for a given tag deployment
%     and file type. Optional chip number is used for SWV, AUDIO,
%     GTX and LOG files.
%
%     mark johnson
%     majohnson@whoi.edu
%     last modified: 24 June 2006
%     modified by stacy deruiter for dtag3, july 2011

fname = [] ; 

if nargin<2,
   help makefname
   return
end

if nargin<3,
   chip = 1 ;
   SILENT = [] ;
end

if nargin<4,
   SILENT = [] ;
end

if nargin>=3,
   if isstr(chip),         % swap arguments if silent comes first
      chip = SILENT ;
      SILENT = 's' ;
   end
end

if length(tag)~=9,
   if isempty(SILENT),
      fprintf(' Tag deployment name must have 9 characters e.g., sw05_199a') ;
   end
   return
end

shortname = tag([1:2 6:9]) ;
subdir = tag(1:4) ;

% make appropriate suffix for the given file type
switch type
   case 'RAW',
         suffix = strcat(tag,'raw.mat') ;
   case 'CAL'
         suffix = strcat(tag,'cal.mat') ;
   case 'PRH'
         suffix = strcat(tag,'prh.mat') ;
   case 'AUD'
         suffix = strcat(tag,'aud.txt') ;
   case 'SWV'
         suffix = sprintf('%s/%s/%s%03d.swv',subdir,tag,shortname,chip) ;
         type = 'AUDIO' ;
%    case 'GTX'
%          suffix = sprintf('%s/%s/%s%02d.gtx',subdir,tag,shortname,chip) ;
%          type = 'AUDIO' ;
   case 'AUDIO'
         suffix = sprintf('%s/%s/%s%03d.wav',subdir,tag,shortname,chip) ;
   case 'LOG'
         suffix = sprintf('%s/%s/%s%03d.log',subdir,tag,shortname,chip) ;
         type = 'AUDIO' ;
   case 'XML'
         suffix = sprintf('%s/%s/%s%03d.xml',subdir,tag,shortname,chip) ;
   case 'RECDIR' %for use with d3 data if settagpath call structure is preferred to inputting tag, recdir.
         suffix = sprintf('%s/%s/', subdir, tag) ; 
         type = 'AUDIO' ;
   otherwise
         fprintf(' Unknown file type: %s', type) ;
         return
end
        
% try to make filename
global TAG_PATHS
if isempty(TAG_PATHS) | ~isfield(TAG_PATHS,type),
   if isempty(SILENT),
      fprintf(' No %s file path - use settagpath\n', type) ;
   end
   return
end
fname = sprintf('%s/%s',getfield(TAG_PATHS,type),suffix) ;
        