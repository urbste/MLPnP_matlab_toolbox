%     Steffen Urban email: urbste@googlemail.com
%     Copyright (C) 2016  Steffen Urban
% 
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 2 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along
%     with this program; if not, write to the Free Software Foundation, Inc.,
%     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

% 28.06.2016 Steffen Urban
% 18.08.2023 Shi Shenglei

function [Rout, tout] = optim_MLPnP_GN(R, t, points3D, rnull, snull, invKll, optimFlags)
    % optim params
    epsParam    = optimFlags.epsP;
    epsFunc     = optimFlags.epsF;

    % iteration params
    cnt = 0;
    while cnt < optimFlags.maxit
        [r, J] = residualsAndJacobian(R, t, points3D, rnull, snull);
        % design matrix
        N = J.'*invKll*J;
        % System matrix
        g = J.'*invKll*r;

        dx = pinv(N)*g;
        if (max(abs(dx)) > 20 || min(abs(dx)) > 1)
            break;
        end

        % update parameter vector
        dR = Rodrigues2(-dx(1:3));
        R = dR * R;
        t = dR * t - dx(4:6);

        dl = J*dx(1:end);
        if max(abs(dl)) < epsFunc || max(abs(dx(1:end))) < epsParam
            break;
        end  
        cnt = cnt+1;
    end % while loop

    Rout = R;
    tout = t;
end
