# NNDigits
Midterm Digits project.

So far it has done what I need it to do.

test.m is the actual file of performing the digit rotation, then classifying.

genrotnet.m generates a separate net that "guesses" the angle by which to rotate the digit.

RotationLayer.m is a custom 2-input layer (of image/angle) that performs the rotation.


# Comments by the Reviewer

* processImagesMNIST is not a MATLAB built-in function. You must provide it for the code to run.
  See: [this link](https://www.mathworks.com/matlabcentral/answers/514716-i-cannot-find-the-helper-functions-processimagesmnist-and-processlabelsmnist)
* Same applies to freezeWeights (in my version of MATLAB, 2022b); but it is easy to freeze the weight, as in this example:
                  convolution2dLayer(3,1,'Padding',[1 1 1 1],'WeightLearnRateFactor',0); 
  I chose to add a version of freezeWeights to your code, as it is floating on the internet.
* genrotate returns values but they are unassigned. The function does work by saving the net.
  That is, the function has side effects which should come with a big warning to the user (like: me).
* Include a short summary of results?
  
## Score: 100%  
