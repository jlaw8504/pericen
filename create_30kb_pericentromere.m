function create_30kb_pericentromere

% assign parameters
mass_mass = 3.38889e-020; % mass of a standard bead
mass_sep = 1e-008; % standard distances betweem masses
spring_rest = 1e-008; % spring distance at rest
spring_const = 0.226195; % standard spring constant
hinge_const = 4.0715e-012; % standard hinge constant
bead_num = 1020;% number of beads in the chain

intro = sprintf('meta temperature_Celsius 25\r\nmeta viscosity_centiPoise 1\r\nmeta effective_damping_radius 8e-009\r\nmeta dna_modulus_gigaPascal 2\r\nmeta dna_radius_nanometers 0.6\r\nmeta damping_radius_factor 0.8\r\nstructure {\r\n  random_force 2.78554e-011\r\n  mass_damping 4.44973e+009\r\n  mass_radius 4.5e-009\r\n  time_step 2e-009\r\n  collision_spring_constant 0.0565487\r\n  spring_damping_factor 0\r\n  random_number_seed 42\r\n  color 1');

% build the straight-chain DNA
for z = 1:bead_num
    % create all the DNA masses
    mass_create{z} = sprintf('  mass %d\t%.6g\t%.6g %.6g %.6g',z-1,mass_mass,(z-1)*mass_sep,0,0);
    if z > 1
        % create the standard DNA spring
        spring_create{z-1} = sprintf('  spring %d %d %.1g %.6g',z-2,z-1,spring_rest,spring_const);
    else
    end
    if z > 2
        % create the standard DNA hinges
        hinge_create{z-2} = sprintf('  hinge %d %d %d %.6g',z-3,z-2,z-1,hinge_const);
    else
    end
end

% open up the file
fid_out = fopen('30kb_peri.cfg','w');

% print out the intro
fprintf(fid_out,'%s\r\n',intro);

% print out the standard masses, springs, and hinges
for z = 1:bead_num
    % print the masses
    fprintf(fid_out,'%s\r\n',mass_create{z});
    if z > 1
        % print the springs
        fprintf(fid_out,'%s\r\n',spring_create{z-1});
    else
    end
    if z > 2
        % print the hinges
        fprintf(fid_out,'%s\r\n',hinge_create{z-2});
    else
    end
end

% print out the end of the structure
fprintf(fid_out,'}\r\n');
