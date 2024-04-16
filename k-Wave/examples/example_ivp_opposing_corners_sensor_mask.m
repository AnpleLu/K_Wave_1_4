% Defining A Sensor Mask By Opposing Corners Example
%
% This example demonstrates how to define a sensor mask using the grid
% coordinates of two opposing corners of a rectangle, and then use this for
% the detection of the pressure field generated by an initial pressure
% distribution within a two-dimensional homogeneous propagation medium. It
% builds on the Homogeneous Propagation Medium and Using A Binary Sensor
% Mask examples.
%
% author: Bradley Treeby
% date: 21st August 2014
% last update: 29th April 2017
%  
% This function is part of the k-Wave Toolbox (http://www.k-wave.org)
% Copyright (C) 2014-2017 Bradley Treeby

% This file is part of k-Wave. k-Wave is free software: you can
% redistribute it and/or modify it under the terms of the GNU Lesser
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
% 
% k-Wave is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
% more details. 
% 
% You should have received a copy of the GNU Lesser General Public License
% along with k-Wave. If not, see <http://www.gnu.org/licenses/>. 

clearvars;

% =========================================================================
% SIMULATION
% =========================================================================

% create the computational grid
Nx = 128;           % number of grid points in the x (row) direction
Ny = 128;           % number of grid points in the y (column) direction
dx = 0.1e-3;        % grid point spacing in the x direction [m]
dy = 0.1e-3;        % grid point spacing in the y direction [m]
kgrid = kWaveGrid(Nx, dx, Ny, dy);

% define the properties of the propagation medium
medium.sound_speed = 1500; 	% [m/s]
medium.alpha_coeff = 0.75;  % [dB/(MHz^y cm)]
medium.alpha_power = 1.5;

% create initial pressure distribution using makeDisc
disc_magnitude = 5; % [Pa]
disc_x_pos = 50;    % [grid points]
disc_y_pos = 50;    % [grid points]
disc_radius = 8;    % [grid points]
disc_1 = disc_magnitude * makeDisc(Nx, Ny, disc_x_pos, disc_y_pos, disc_radius);

disc_magnitude = 3; % [Pa]
disc_x_pos = 80;    % [grid points]
disc_y_pos = 60;    % [grid points]
disc_radius = 5;    % [grid points]
disc_2 = disc_magnitude * makeDisc(Nx, Ny, disc_x_pos, disc_y_pos, disc_radius);

source.p0 = disc_1 + disc_2;

% define the first rectangular sensor region by specifying the location of
% opposing corners
rect1_x_start = 25;
rect1_y_start = 31;
rect1_x_end = 30;
rect1_y_end = 50;

% define the second rectangular sensor region by specifying the location of
% opposing corners
rect2_x_start = 71;
rect2_y_start = 81;
rect2_x_end = 80;
rect2_y_end = 90;

% assign the list of opposing corners to the sensor mask
sensor.mask = [rect1_x_start, rect1_y_start, rect1_x_end, rect1_y_end;...
               rect2_x_start, rect2_y_start, rect2_x_end, rect2_y_end].';

% run the simulation
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor);

% query the size of the output data - note that when using a sensor mask
% defined using opposing corners, the output data is returned as a
% structure
size(sensor_data(1).p)
size(sensor_data(2).p)

% =========================================================================
% VISUALISATION
% =========================================================================

% plot a time trace from the centre of each rectangle
figure;
plot(squeeze(sensor_data(1).p(end/2, end/2, :)), 'r-');
hold on;
plot(squeeze(sensor_data(2).p(end/2, end/2, :)), 'b-');
legend('Trace from centre of first rectangle', 'Trace from centre of second rectangle');
xlabel('Time Index');
ylabel('Pressure');
axis tight;