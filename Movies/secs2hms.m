function time_string=secs2hms(time_in_secs)
time_string='';
nhours = 0;
nmins = 0;
ndays = 0;
if time_in_secs >= 3600*24
    ndays = floor(time_in_secs/(3600*24));
    if ndays > 1
        day_string = ' days ';
    else
        day_string = ' day ';
    end
    time_string = [num2str(ndays) day_string];
    time_in_secs = time_in_secs - 3600*24*ndays;
end
if time_in_secs >= 3600
    nhours = floor(time_in_secs/3600);
    if nhours > 1
        hour_string = 'h ';
    else
        hour_string = 'h ';
    end
    time_string = [time_string num2str(nhours) hour_string];
    time_in_secs = time_in_secs - nhours*3600;
end
if time_in_secs >= 60
    nmins = floor((time_in_secs)/60);
    if nmins > 1
        minute_string = 'm ';
    else
        minute_string = 'm ';
    end
    time_string = [time_string num2str(nmins) minute_string];
    time_in_secs = time_in_secs - nmins*60;
end
if time_in_secs > 0
    nsecs = time_in_secs;
    % nsecs = time_in_secs - 3600*nhours - 60*nmins;
    time_string = [time_string num2str(nsecs) 's'];
end
end
