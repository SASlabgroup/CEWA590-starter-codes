## How do I choose the arguments for SciPy's welch or MATLAB's pwelch functions?

_Some background first:_ The idea behind Welch's method is that you are estimating the power spectral density of a time series _x_ which is stationary (statistics do not change in time).  To get the best estimate (least noisy), the time series is divided into several segments which each have a length of **nperseg** (**window** in MATLAB).  The function then demeans[^1] and takes the FFT of each segment, and eventually averages all the FFT segments across frequencies to give you a single spectrum which will be smoother than if you had estimated it using the entire record (i.e., if **nperseg** = len(_x_)) _at the cost of frequency resolution_ (more on this below).  We can do this because the whole record is stationary.  This method is further improved if we let the segments overlap (the **noverlap** keyword argument), apply a "window" to each segment such that the beginning and end taper to zero (the **window** keyword), or in some cases, if you zero-pad the segment with the **nfft** keyword (artificially extend it using 0's).

Thus the most important parameter to change is **nperseg** (equivalent to the integer provided to **window** in MATLAB). This is the length of each segment in number of points, therefore if you want to divide your hour-long time series into segments of 256 seconds, then **nperseg** = 256 seconds * [sampling rate in Hz].   The **noverlap** argument is also defined in the number of points.  Using overlapping windows is a good idea, which is why the SciPy and MATLAB welch functions uses a default of **noverlap** = **nperseg** // 2 which is an overlap of ~50% ("//" just does division but discards the remainder so that you get an integer that as close as possible to dividing by 2).  The default window is already Hann (or Hamming in MATLAB), so no need to get fancier than that, and there's no need to change **nfft** here either.

_Choosing the record length:_ As far as ocean waves are concerned, we want to observe enough waves in a time record to be sure it is stationary.  It's typical to use records that are 30 to 60 minutes (1800 s to 3600 s).  For example,  if most of the waves have a 6-second period, an 1800 second record has 300 wave realizations in the whole time series.  But if the majority of the waves are longer (e.g., 10 seconds) and the record is too short, we run the risk of have too little observations. 

Choosing the segment length:  The spectrum you get out of welch (assuming **nfft** is not set) is going to have:

- a maximum frequency which corresponds to the Nyquist frequency = sampling rate / 2 (= 1.28 Hz /2 for CDIP's data)
- a frequency resolution (the width/spacing of each frequency bin in Hz) which is close to the inverse of the segment length in seconds (e.g., 1/256s), and
- a minimum frequency (not including 0, the mean offset) which is also equal to the inverse of the segment length. i.e., the longest period wave you can resolve is the longest wave that will fit in a segment. 
Therefore when choosing the segment size for Welch's method, we are effectively trading spectral noise for reduced frequency resolution.  The ocean waves we're interested in range in frequency from 0.05 Hz to 0.5 Hz, thus sampling at 1.28 Hz (Nyquist frequency = 0.64 Hz) and using a window size of 256 seconds (minimum frequency of 1/256 s = 0.0078 Hz) is sufficient to give us a spectrum that covers this range with reasonable resolution. 

I encourage you to confirm the Nyquist frequency, frequency resolution, and minimum frequency above yourself by comparing the output frequency array to the sampling rate and segment length.  Definitely try adjusting the segment length; you should notice that reducing the segment length makes the spectrum significantly less noisy.

[^1]: In MATLAB, you will have to demean the signal yourself by subtracting the mean of each segment from every value in the segment.