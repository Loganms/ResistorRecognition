function [ norm ] = rgb2nrgb( im )
%RGB2NRGB converts an rgb image to normalized rgb

R = double(im(:,:,1));
G = double(im(:,:,2));
B = double(im(:,:,3));

NormalizedRed = R(:,:)./sqrt(R(:,:).^2+G(:,:).^2+B(:,:).^2);
NormalizedGreen = G(:,:)./sqrt(R(:,:).^2+G(:,:).^2+B(:,:).^2);
NormalizedBlue = B(:,:)./sqrt(R(:,:).^2+G(:,:).^2+B(:,:).^2);

norm(:,:,1) = NormalizedRed(:,:);
norm(:,:,2) = NormalizedGreen(:,:);
norm(:,:,3) = NormalizedBlue(:,:);

end