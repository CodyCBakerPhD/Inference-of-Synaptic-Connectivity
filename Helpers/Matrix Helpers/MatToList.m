
% List = MatToList(Mat)
%
% General purpose function for converting matrices to lists. Currently
% extracts off-diagonal elements from the upper triangle. Automatically
% detects type of matrix (string,numeric). May add future option to 
% specifiy folding, etc.

% To do: Add option for whether or not to include diagonal elements, or if
% its symmetric to include both triangles.

function List = MatToList(Mat)
    
    N = size(Mat,1);
    
    if (size(Mat,2) ~= N)
        List = Mat(:);
    else
        if ( isstring(Mat(1,1)) )
            List = Mat;
            List( logical(tril(ones(N,N)) )) = 'NaN';
            List = List(List ~= 'NaN');
        end

        if ( isnumeric(Mat(1,1)) )
            List = Mat;
            List( logical(tril(ones(N,N)) )) = NaN;
            List = List(~isnan(List));
        end
    end
end

