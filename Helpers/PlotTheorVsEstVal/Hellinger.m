
% Returns the Hellinger distance between two density or mass functions

% If density: assumes normalized or nearly normalized f over the same
% interval x

function dist = Hellinger(type,f1,f2,x)
    
    switch type
        case 'cont'
            dist = trapz(x, sqrt(f1.*f2) );
        case 'disc'
        otherwise
            error('Pass one of "cont" or "disc" into Hellinger function.')
    end
end