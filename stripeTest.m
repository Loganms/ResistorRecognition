function [ bool ] = stripeTest( perpetrator )
    %stripeTest Given a potential resistor, this function runs a test to 
    % see if it has typical characteristics such as number of stripes and
    % sustained intensity
    
    % Minimum number of stripes that must be encountered
    stripeThreshold = 5;
    % The intensity value of a capacitor
    capIntensityThresh = 233;
    % Percentage of the intensity plot that must be continuously above the
    % capIntensityThresh
    capThresholdPercent = 37;
    % Size of derivative estimate
    derivativeEstimate = 5;
    
    labTransform = makecform('srgb2lab');
    % Convert to desired color space
    lab_perpetrator = applycform(perpetrator, labTransform);
    
    %figure
    %imshow(lab_perpetrator(:,:,1),[]);
    [r,c] = size(lab_perpetrator(:,:,1));

    % Apply a Gaussian filter
    filt_perpetrator = imgaussfilt(lab_perpetrator, 5.5);
    %filteredSuspect = medfilt2(labSuspect(:,:,1),[7 7]);
    %h = ones(6,6)/36;
    %filt_perpetrator = imfilter(lab_perpetrator, h, 'conv');
    %figure
    %imshow(filt_perpetrator(:,:,1))

    % Grab the middle columns 
    columnVectors = filt_perpetrator(:,(floor(c/2)-5):(floor(c/2)+ 5),1);
    
    % Average each row and place into a column vector
    columnStrip = mean(columnVectors.');
    
    % Find the maximum value in the vector
    max_columnStrip = max(columnStrip(:,:,1));
    
    % Normalize the vector according to the max value
    columnStrip = (columnStrip(:,:,1)/max_columnStrip) * 255;

    x = linspace(1, r, r);
    %figure
    %plot(x, columnStrip(:,:,1))

    % Count the number of derivatives
    numPixels = length(columnStrip);
    columnStripSigned = int16(columnStrip);

    slope = int8(columnStripSigned(2) - columnStripSigned(1));

    if (slope >= 0)
        positive = true;
    else
        positive = false;
    end

    stripeCount = 0;
    
    % A percentage of the overall vector length
    capLength = (capThresholdPercent/100) * numPixels;
    count = 0;
    capFound = false;
    
    for i = derivativeEstimate + 1 : numPixels 
        
       slope = int8(columnStripSigned(i) - columnStripSigned(i - derivativeEstimate));

       % If intensity is above the capacitor threshold
       if (columnStripSigned(i) > capIntensityThresh)
           % Add one to the count
           count = count + 1;
           % If the count reached the limit
           if (count > capLength)
               % Determine it was a capacitor
               capFound = true;
           end
       else
           % Otherwise, reset the count
           count = 0;
       end
       
       % If derivative changes directions, add one to count
       if (slope >= 0)
          if (positive == 0)
              stripeCount = stripeCount + 1;
          end  
          positive = 1;
       else
          if (positive == 1)
              stripeCount = stripeCount + 1;
          end 
          positive = 0;
       end
    end
    
    if ((stripeCount >= stripeThreshold) && (capFound == false))
        bool = true;
    else
        bool = false;
    end
    
    % (For display purposes)
    if (capFound)
        capFound;
    end
    
    stripeCount;
end
