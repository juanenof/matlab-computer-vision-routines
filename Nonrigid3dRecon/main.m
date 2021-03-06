addpath( '~/Code/PointCloudGenerator/' );
addpath( genpath( '~/Code/third_party/CoherentPointDrift/' ) );
addpath( '~/Code/plant_registration' );
NUM_IMAGES_IN_SEQUENCE = 100;
X_rigid=cell(NUM_IMAGES_IN_SEQUENCE,1);
Y_rigid=cell(NUM_IMAGES_IN_SEQUENCE,1);
Z_rigid=cell(NUM_IMAGES_IN_SEQUENCE,1);

%m=1;
%for k=0:2%NUM_IMAGES_IN_SEQUENCE-1 % compute and rigidly register each set
%of 7 range images
%end % end outer loop


%{
X_left =  [X_rigid{1}',Y_rigid{1}',Z_rigid{1}'];
X_right = [X_rigid{2}',Y_rigid{2}',Z_rigid{2}'];
num_rigid_iters = 0;
num_nonrigid_iters = 25;
[Y1_pair_nonrigid,Y2_pair_nonrigid,Y3_pair_nonrigid,Trans] = ...
           registerToReferenceRangeScan( X_left,X_right, ...
                                          num_rigid_iters,num_nonrigid_iters, ...
                                          lambda, beta );
%}
%%%%%%%%%%%%%%[ X_rigid,Y_rigid,Z_rigid ] = registerFramesAtSameInstant( 0 );
MinZ =44.;
MaxZ = 120.;
k = 0;
%X =  [X_rig',Y_rig',Z_rig'];
depth_im_1 = imread( sprintf('~/Data/BreakdancerDepthMaps/depthcam%df%03d.bmp', [1 k]) );

X_reg = cell(6,1);
Y_reg = cell(6,1);
Z_reg = cell(6,1);
for i=3:6

depth_im_2 = imread( sprintf('~/Data/BreakdancerDepthMaps/depthcam%df%03d.bmp', [i k+1]) );
z_one = getZImage( depth_im_1,MinZ,MaxZ );
z_two = getZImage( depth_im_2,MinZ,MaxZ );

num_rigid_iters = 0;
num_nonrigid_iters = 40;
lambda = 1; beta = 1;
fgt = 2;
[x_mesh,y_mesh] = meshgrid( 0:size(z_one,2)-1,size(z_one,1)-1:-1:0);

silhouetteImOne = z_one > 55 & z_one < 60 & y_mesh > 150;
X =  get3dPointsFromDepthMap( silhouetteImOne,x_mesh,y_mesh,z_one );
silhouetteImTwo = z_two > 55 & z_two < 60 & y_mesh > 150;
Y =  get3dPointsFromDepthMap( silhouetteImTwo,x_mesh,y_mesh,z_one );

[Y1_registered,Y2_registered,Y3_registered,Trans] = ...
           registerToReferenceRangeScan( X',Y', ...
                                         num_rigid_iters,num_nonrigid_iters, ...
                                         lambda, beta, fgt );
X_reg{i} = Y1_registered;
Y_reg{i} = Y2_registered;
Z_reg{i} = Y3_registered;                                     

end