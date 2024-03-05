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
extra_cols = event_catalog(:, 7:end);

var_names = ['DateTime', extra_cols.Properties.VariableNames];

data_out=table(datetimes, extra_cols,'VariableNames',var_names);
end