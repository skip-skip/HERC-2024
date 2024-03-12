function data_out = importEventCatalog(catalog_file,header_row)
%Pre-process event data from a CSV
%   Creates a table with datetimes and any further data from the original
%   file

event_catalog = readtable(catalog_file,"NumHeaderLines",header_row);

years = event_catalog.Year;
months = event_catalog.Month;
days = event_catalog.Day;
hr = event_catalog.Hour;
min = event_catalog.Minute;
sec = event_catalog.Second;
datetimes = datetime(years, months, days, hr, min, sec);
event_codes = event_catalog.Event_Code;

var_names = {'DateTime', 'EventCode'};

data_out=table(datetimes, event_codes,'VariableNames',var_names);
end