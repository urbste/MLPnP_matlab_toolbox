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

function [err,J] = residualsAndJacobian(R, t, points3D, r, s)
    nrPts = size(points3D,2);
    err = zeros(2*nrPts,1);
    J = zeros(2*nrPts,6);

    res1 = R*points3D+repmat(t,1,nrPts);
    for i=1:nrPts
        err(2*i-1,1) = r(:,i)'*res1(:,i);
        err(2*i,1) = s(:,i)'*res1(:,i);

        J(2*i-1,:) = [-r(:,i)'*skew(res1(:,i)) r(:,i)'];
        J(2*i,:) = [-s(:,i)'*skew(res1(:,i)) s(:,i)'];
    end
end
