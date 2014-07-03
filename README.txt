Visualizer for Ross Hatton, Version 1 (dev)

- Open MATLAB
- Add the installation directory to the MATLAB path

Visualizer + Control Panel ONLY:

- Enter in the command console:
caster_startup;

Everything within this program should run in an encapsulated fashion; 
once the GUIS are closed, all program information is erased.

To run in a mode where you can see all of the program information, run:

ph = caster_startup_debug

The visualizer should load and the variable ph will store the program 
handles for the entire program. Through the program handles, you can view 
the data from the entire application and make adjustments if necessary.

Visualizer + Control Panel + Simulink Plugin Demonstration

Enter in command console:
caster_startup_simulink.

Similarly, use 
ph = caster_startup_simulink_debug
To retain all program handles.

Coming in Summer 2014:

- Animation Plugin for Visualizer

For questions, contact David Rebhuhn at rebhuhnd@onid.orst.edu