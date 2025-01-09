%FEA
denk = sum( H(EleNodesID).^2, 2 ) / 4; 
den=sum( H(EleNodesID), 2 ) / 4;
A1=sum(den)*EW*EH;                     
U = zeros(2*(nely+1)*(nelx+1),1);
sK = KE(:)*denk(:)';
K = sparse(iK(:),jK(:),sK(:)); K = (K+K')/2;
U(freedofs,:) = K(freedofs,freedofs)\F(freedofs,:);