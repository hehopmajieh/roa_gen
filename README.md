# ROA Generator for Bird


## Requirements
IRR lib for perl
```bash
sudo apt install libnet-irr-perl
```
## Use

```bash
./roa_generator.pl --list 'AS-LIST|AS_SET' --roa_name 'ROA Table Name' --out 'file to write'
```
 - **--list** - AS Number list or  AS-SET ex.  `` --list 'AS342 AS112 AS120' ``  or `` --list 'AS-ELI' ``
 - **--roa_name** - table name `` roa table r<roa_name> { ``

## Issues
This comes with no warranty !!!
