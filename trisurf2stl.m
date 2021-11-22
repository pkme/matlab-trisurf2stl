function trisurf2stl(filename,k,v,mode,writemode)

% Export the model represented by triangular surface built in Matlab to STL file.
%
%   filename is the STL file to be saved.
%   k is a three-column matrix where each row represents a triangular facet. The values represent the row indices of the input points.
%   v is a three-column matrix. v= [X,Y,Z]
%
%   This program is rewritten from surf2stl of Bill McDonald.
%
%   Author: Weidong Shen 2021/11/22

if (nargin < 4)
    mode = 'binary';
elseif (strcmp(mode,'ascii')==0)
    mode = 'binary';
end

if strcmp(mode,'ascii')
    % Open for writing in ascii mode
   % fid = fopen(filename,'w');
   fid = fopen(filename,writemode);
else
    % Open for writing in binary mode
    fid = fopen(filename,'wb+');
end

if (fid == -1)
    error( sprintf('Unable to write to %s',filename) );
end

title_str = sprintf('Created by surf2stl.m %s',datestr(now));

if strcmp(mode,'ascii')
    fprintf(fid,'solid %s\r\n',title_str);
else
    str = sprintf('%-80s',title_str);    
    fwrite(fid,str,'uchar');         % Title
    fwrite(fid,0,'int32');           % Number of facets, zero for now
end

nfacets = 0;

for i=1:(size(k,1))
    p1 = [v(k(i,1),1) v(k(i,1),2) v(k(i,1),3)];
    p2 = [v(k(i,2),1) v(k(i,2),2) v(k(i,2),3)];
    p3 = [v(k(i,3),1) v(k(i,3),2) v(k(i,3),3)];    
    val = local_write_facet(fid,p1,p2,p3,mode);
    nfacets = nfacets + val;
end

if strcmp(mode,'ascii')
    fprintf(fid,'endsolid %s\r\n',title_str);
else
    fseek(fid,0,'bof');
    fseek(fid,80,'bof');
    fwrite(fid,nfacets,'int32');
end

fclose(fid);

% Local subfunctions
function num = local_write_facet(fid,p1,p2,p3,mode)

if any( isnan(p1) | isnan(p2) | isnan(p3) )
    num = 0;
    return;
else
    num = 1;
    n = local_find_normal(p1,p2,p3);
    
    if strcmp(mode,'ascii')
        
        fprintf(fid,'facet normal %.7E %.7E %.7E\r\n', n(1),n(2),n(3) );
        fprintf(fid,'outer loop\r\n');        
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p1);
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p2);
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p3);
        fprintf(fid,'endloop\r\n');
        fprintf(fid,'endfacet\r\n');
        
    else
        
        fwrite(fid,n,'float32');
        fwrite(fid,p1,'float32');
        fwrite(fid,p2,'float32');
        fwrite(fid,p3,'float32');
        fwrite(fid,0,'int16');  % unused
        
    end
    
end


function n = local_find_normal(p1,p2,p3)

v1 = p2-p1;
v2 = p3-p1;
v3 = cross(v1,v2);
n = v3 ./ sqrt(sum(v3.*v3));