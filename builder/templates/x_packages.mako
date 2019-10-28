<%def name="expand_md_list(module_list)">
| Module | Description |
|:------:|:------------|
% for m in module_list:
| `${m["Name"]}` | ${m["Description"]} |
%endfor
</%def>

<%def name="expand_package_list(package_list)">
| Module | Version | Description |
|:------:|:-------:|:------------|
% for p in package_list:
| `${p["Package"]}` | ${p["Version"]} | ${p["Title"]} |
%endfor
</%def>

