% MSIPROCESSOR Read and process mzXML files for data aquisition

function msiProcessor
%% Start of the main function

init_window;
init_parameters;
alloc_elements;
init_gui;
debug('off');

%% End of the main function
end


%% Workflow functions
%  ========================================================================
%  Here are the functions that generates the UI setting in each step. These
%  functions decide the workflow of the msiProcessor.

%% 1. Initializing functions
%% 1.1. Initialize UI window
function init_window
%  Description:
%    Initialize the UI window with the tag 'msiProcessor', and load the
%    guide images. The UI window is turned off by default.
% -------------------------------------------------------------------------
uiHandles.window = figure( ...
    'Menubar', 'none', ...
    'Resize', 'off', ...
    'Visible', 'off', ...
    'Name', 'MSI Processor version 2.0', ...
    'Tag', 'msiProcessor', ...
    'IntegerHandle', 'off');

% Deployed version of the code has different path than the MATLAB version
if isdeployed
    guideImg = imread(fullfile(ctfroot, 'msiProcessor', 'msiProcessor_Guide.jpg'));
else
    [currentPath,~,~] = fileparts(mfilename('fullpath'));
    guideImg = imread(fullfile(currentPath, 'msiProcessor_Guide.jpg'));
end

% Store the guide images and the size of them
uiSize.dynamic.guide = [size(guideImg, 1) size(guideImg, 2)/2];
uiImage.guide.original = guideImg(:, 1:uiSize.dynamic.guide(1,2), :);
uiImage.guide.keyboard = guideImg(:, uiSize.dynamic.guide(1,2)+1:end, :);

gui_data(uiHandles, uiSize, [], uiImage, [], []);
end

%% 1.2. Initialize parameters
function init_parameters
%  Description:
%    Initialize the constants which are used to set up the size of each UI
%    elements. The values here can be modifyed freely, and the unit of them
%    are in pixels.
% -------------------------------------------------------------------------
[~, uiSize, ~, ~, ~, ~] = gui_data;

% The size of the gaps between elements
uiSize.const.gap.panel = 20;
uiSize.const.gap.outer = 10;
uiSize.const.gap.inner = 10;
uiSize.const.gap.thin = 5;

% The size of the panels
uiSize.const.panel.ht = 550;
uiSize.const.panel.wd.left = 300;

% The size of the elements in the slider group
uiSize.const.scroll.wd.slider = 30;
uiSize.const.scroll.wd.colorbar = 10;
uiSize.const.scroll.ht.button = 10;
uiSize.const.scroll.wd.textbox = 75;

% The size of the basic elements
uiSize.const.setting.ht.textbox = 21;
uiSize.const.setting.ht.text = 16;
uiSize.const.setting.wd.button = 60;
uiSize.const.setting.wd.textbox = 120;

% The size of the main buttons
uiSize.const.main.ht.button = 35;

% The size of the magnifier
uiSize.const.magnifier = 150;

gui_data([], uiSize, [], [], [], []);
end

%% 1.3. Allocate element sizes
function alloc_elements
%  Description:
%    Calculate the element size of every UI elements. The sizes are used to
%    initialize the GUI in the next step.
% -------------------------------------------------------------------------
[~, uiSize, ~, ~, ~, ~] = gui_data;

%% [][][o] Size properties of the panel on the right
%  Size of the user guide panel
uiSize.right.panel = uiSize.const.panel.ht/uiSize.dynamic.guide(1,1)*[ ...
    uiSize.dynamic.guide(1,2) ...
    uiSize.dynamic.guide(1,1)];

%% [][o][] Size properties of the panel on the middle
%  Size of the scroll group
uiSize.mid.scroll.group = [ ...
    uiSize.const.scroll.wd.slider+uiSize.const.scroll.wd.colorbar+uiSize.const.gap.thin ...
    uiSize.const.panel.ht-2*uiSize.const.gap.outer];

uiSize.mid.scroll.textbox = [ ...
    uiSize.mid.scroll.group(1,1) ...
    uiSize.const.setting.ht.textbox];

uiSize.mid.scroll.slider = [ ...
    uiSize.const.scroll.wd.slider ...
    uiSize.mid.scroll.group(1,2)-(uiSize.mid.scroll.textbox(1,2)+uiSize.const.gap.inner)];

uiSize.mid.scroll.colorbar = [ ...
    uiSize.const.scroll.wd.colorbar ...
    uiSize.mid.scroll.slider(1,2)-2*uiSize.const.scroll.ht.button];

%  Size of the main figure axes
uiSize.mid.axes = [ ...
    uiSize.mid.scroll.slider(1,2) ...
    uiSize.mid.scroll.slider(1,2)];

% Size of the main magnifier axes
uiSize.mid.magnifier = [ ...
    uiSize.const.magnifier ...
    uiSize.const.magnifier];

%  Size of the middle setting group
uiSize.mid.setting.group = [ ...
    (uiSize.mid.axes(1,1)-2*uiSize.const.gap.inner-3*uiSize.const.gap.thin)/3 ...
    uiSize.const.setting.ht.textbox];

uiSize.mid.setting.textbox = [ ...
    uiSize.const.scroll.wd.textbox ...
    uiSize.mid.setting.group(1,2)];

uiSize.mid.setting.text = [ ...
    uiSize.mid.setting.group(1,1)-uiSize.mid.setting.textbox(1,1) ...
    uiSize.const.setting.ht.text];

%  Size of the middle UI panel
uiSize.mid.panel = [ ...
    uiSize.mid.axes(1,1)+uiSize.mid.scroll.group(1,1)+uiSize.const.gap.inner+2*uiSize.const.gap.outer ...
    uiSize.mid.axes(1,2)+uiSize.mid.setting.group(1,2)+uiSize.const.gap.inner+2*uiSize.const.gap.outer];

%% [o][][] Size properties of the panel on the left
%  Size of the left directory selection group
uiSize.left.dir.group = [ ...
    uiSize.const.panel.wd.left-2*uiSize.const.gap.outer ...
    uiSize.const.setting.ht.text+uiSize.const.setting.ht.textbox];

uiSize.left.dir.text = [ ...
    uiSize.left.dir.group(1,1) ...
    uiSize.const.setting.ht.text];

uiSize.left.dir.button = [ ...
    uiSize.const.setting.wd.button ...
    uiSize.const.setting.ht.textbox];

uiSize.left.dir.textbox = [ ...
    uiSize.left.dir.group(1,1)-uiSize.left.dir.button(1,1)-uiSize.const.gap.inner ...
    uiSize.const.setting.ht.textbox];

%  Size of the left setting group
uiSize.left.setting.group = [ ...
    uiSize.left.dir.group(1,1) ...
    uiSize.const.setting.ht.textbox];

uiSize.left.setting.textbox = [ ...
    uiSize.const.setting.wd.textbox ...
    uiSize.const.setting.ht.textbox];

uiSize.left.setting.text = [ ...
    uiSize.left.setting.group(1,1)-uiSize.left.setting.textbox(1,1)-uiSize.const.gap.thin ...
    uiSize.const.setting.ht.text];

%  Size of the left button
uiSize.left.main.button = [ ...
    uiSize.left.dir.group(1,1) ...
    uiSize.const.main.ht.button];

uiSize.left.main.halfbutton = [ ...
    (uiSize.left.dir.group(1,1)-uiSize.const.gap.inner)/2 ...
    uiSize.const.main.ht.button];


%  Size of the left status
uiSize.left.status.icon = [ ...
    uiSize.const.setting.ht.text ...
    uiSize.const.setting.ht.text];

uiSize.left.status.text = [ ...
    uiSize.left.dir.group(1,1)-uiSize.left.status.icon(1,1) ...
    uiSize.const.setting.ht.text];

%  Size of the left UI panel
uiSize.left.panel = [ ...
    uiSize.const.panel.wd.left ...
    uiSize.const.panel.ht];

%% [ | | ] Size properties of the UI window
uiSize.window = [ ...
    uiSize.left.panel(1,1)+uiSize.mid.panel(1,1)+uiSize.right.panel(1,1)+4*uiSize.const.gap.panel ...
    uiSize.left.panel(1,2)+2*uiSize.const.gap.panel];

uiSize.resolution = uiSize.mid.axes(1,1);

gui_data([], uiSize, [], [], [], []);
end

%% 1.4. Initialize UI elements
function init_gui
%  Description:
%    Initialize the UI elements and turn on the UI window. All UI elements
%    are turned off by default.
% -------------------------------------------------------------------------
[uiHandles, uiSize, ~, ~, ~, ~] = gui_data;

%% [ | | ] Turn on UI window
%  Retrieve the screen size and turn on the UI window
scrnSize = get(0,'ScreenSize');
uiPosition = [ ...
    (scrnSize(1,3)-uiSize.window(1,1))/2 ...
    (scrnSize(1,4)-uiSize.window(1,2))/2 ...
    uiSize.window];
set(uiHandles.window, ...
    'Position', uiPosition, ...
    'Visible', 'on');

%  Create UI panels
uiHandles.left.panel = uipanel(uiHandles.window, ...
    'Units', 'pixels', ...
    'Position', [ ...
    uiSize.const.gap.panel ...
    uiSize.const.gap.panel ...
    uiSize.left.panel]);

uiHandles.mid.panel = uipanel(uiHandles.window, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.left.panel, uiSize.const.gap.panel, uiSize.mid.panel));

uiHandles.right.panel = axes( ...
    'Parent', uiHandles.window, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.mid.panel, uiSize.const.gap.panel, uiSize.right.panel), ...
    'Visible', 'off', ...
    'PickableParts', 'none');

%% [][][o] Initialize right-panel elements
%  Create right guide text group
uiHandles.right.guide.text(1,1) = text(...
    25, ... % X coord
    100, ... % Y coord
    '', ...
    'Color', [0.4 0.4 0.4], ...
    'FontSize', 9, ...
    'Interpreter', 'tex');

%% [][o][] Initialize middle-panel elements
%  Create middle figure axes
uiHandles.mid.axes = axes( ...
    'Parent', uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', [ ...
    uiSize.const.gap.outer ...
    uiSize.mid.panel(1,2)-(uiSize.mid.axes(1,2)+uiSize.const.gap.outer) ...
    uiSize.mid.axes], ...
    'Visible', 'off', ...
    'SortMethod', 'childorder');

% Create middle magnifier axes
uiHandles.mid.magnifier.axes = axes( ...
    'Parent', uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', [ ...
    uiSize.const.gap.outer ...
    uiSize.mid.panel(1,2)-(uiSize.mid.magnifier(1,2)+uiSize.const.gap.outer) ...
    uiSize.mid.magnifier], ...
    'Visible', 'off', ...
    'SortMethod', 'childorder');

%  Create middle setting group
uiHandles.mid.setting(1,3).textbox = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('br', uiHandles.mid.axes, uiSize.const.gap.inner, uiSize.mid.setting.textbox), ...
    'Style', 'edit', ...
    'String', '0.01', ...
    'HorizontalAlignment', 'right', ...
    'Enable', 'off');

uiHandles.mid.setting(1,3).text = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.mid.setting(1,3).textbox, uiSize.const.gap.thin, uiSize.mid.setting.text), ...
    'Style', 'text', ...
    'String', 'Scaling(%):', ...
    'HorizontalAlignment', 'right');

uiHandles.mid.setting(1,2).textbox = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.mid.setting(1,3).text, uiSize.const.gap.inner, uiSize.mid.setting.textbox), ...
    'Style', 'edit', ...
    'String', '1', ...
    'HorizontalAlignment', 'right', ...
    'Enable', 'off');

uiHandles.mid.setting(1,2).text = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.mid.setting(1,2).textbox, uiSize.const.gap.thin, uiSize.mid.setting.text), ...
    'Style', 'text', ...
    'String', 'Rotation(deg):', ...
    'HorizontalAlignment', 'right');

uiHandles.mid.setting(1,1).textbox = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.mid.setting(1,2).text, uiSize.const.gap.inner, uiSize.mid.setting.textbox), ...
    'Style', 'edit', ...
    'String', '1', ...
    'HorizontalAlignment', 'right', ...
    'Enable', 'off');

uiHandles.mid.setting(1,1).text = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.mid.setting(1,1).textbox, uiSize.const.gap.thin, uiSize.mid.setting.text), ...
    'Style', 'text', ...
    'String', 'Translation(px):', ...
    'HorizontalAlignment', 'right');

%  Create middle scroll group
uiHandles.mid.scroll.coloraxes = axes( ...
    'Parent', uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rm', uiHandles.mid.axes, uiSize.const.gap.inner, uiSize.mid.scroll.colorbar), ...
    'Visible', 'off');

uiHandles.mid.scroll.slider = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rm', uiHandles.mid.scroll.coloraxes, uiSize.const.gap.thin, uiSize.mid.scroll.slider), ...
    'Style', 'slider', ...
    'Callback', [], ...
    'Enable', 'off');

uiHandles.mid.scroll.textbox = uicontrol(uiHandles.mid.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('br', uiHandles.mid.scroll.slider, uiSize.const.gap.inner, uiSize.mid.scroll.textbox), ...
    'Style', 'edit', ...
    'String', '500', ...
    'HorizontalAlignment', 'right', ...
    'Callback', [], ...
    'Enable', 'off');

%% [o][][] Initialize left-panel elements
%  Create left directory group
uiHandles.left.dir(1,1).text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', [ ...
    uiSize.const.gap.outer ...
    uiSize.left.panel(1,2)-(uiSize.left.dir.text(1,2)+uiSize.const.gap.outer) ...
    uiSize.left.dir.text], ...
    'Style', 'text', ...
    'String', 'Folder of mzXML files', ...
    'HorizontalAlignment', 'left');

uiHandles.left.dir(1,1).textbox = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('bl', uiHandles.left.dir(1,1).text, 0, uiSize.left.dir.textbox), ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Enable', 'off');

uiHandles.left.dir(1,1).button = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.left.dir(1,1).textbox, uiSize.const.gap.inner, uiSize.left.dir.button), ...
    'Style', 'pushbutton', ...
    'String', 'Browse', ...
    'Callback', [], ...
    'Enable', 'off');

uiHandles.left.dir(1,2).text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('bl', uiHandles.left.dir(1,1).textbox, uiSize.const.gap.inner, uiSize.left.dir.text), ...
    'Style', 'text', ...
    'String', 'Marked HE stained image', ...
    'HorizontalAlignment', 'left');

uiHandles.left.dir(1,2).textbox = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('bl', uiHandles.left.dir(1,2).text, 0, uiSize.left.dir.textbox), ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Enable', 'off');

uiHandles.left.dir(1,2).button = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.left.dir(1,2).textbox, uiSize.const.gap.inner, uiSize.left.dir.button), ...
    'Style', 'pushbutton', ...
    'String', 'Browse', ...
    'Callback', [], ...
    'Enable', 'off');

uiHandles.left.dir(1,3).text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('bl', uiHandles.left.dir(1,2).textbox, uiSize.const.gap.inner, uiSize.left.dir.text), ...
    'Style', 'text', ...
    'String', 'Raw HE stained image (optional)', ...
    'HorizontalAlignment', 'left');

uiHandles.left.dir(1,3).textbox = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('bl', uiHandles.left.dir(1,3).text, 0, uiSize.left.dir.textbox), ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Enable', 'off');

uiHandles.left.dir(1,3).button = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.left.dir(1,3).textbox, uiSize.const.gap.inner, uiSize.left.dir.button), ...
    'Style', 'pushbutton', ...
    'String', 'Browse', ...
    'Callback', [], ...
    'Enable', 'off');

%  Create left setting group
uiHandles.left.setting(1,1).textbox = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('br', uiHandles.left.dir(1,3).button, uiSize.const.gap.inner, uiSize.left.setting.textbox), ...
    'Style', 'edit', ...
    'String', '1000', ...
    'HorizontalAlignment', 'right', ...
    'Enable', 'off');

uiHandles.left.setting(1,1).text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.left.setting(1,1).textbox, uiSize.const.gap.thin, uiSize.left.setting.text), ...
    'Style', 'text', ...
    'String', 'Upper m/z boundary:', ...
    'HorizontalAlignment', 'left');

uiHandles.left.setting(1,2).textbox = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('br', uiHandles.left.setting(1,1).textbox, uiSize.const.gap.inner, uiSize.left.setting.textbox), ...
    'Style', 'edit', ...
    'String', '100', ...
    'HorizontalAlignment', 'right', ...
    'Enable', 'off');

uiHandles.left.setting(1,2).text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.left.setting(1,2).textbox, uiSize.const.gap.thin, uiSize.left.setting.text), ...
    'Style', 'text', ...
    'String', 'Lower m/z boundary:', ...
    'HorizontalAlignment', 'left');

uiHandles.left.setting(1,3).textbox = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('br', uiHandles.left.setting(1,2).textbox, uiSize.const.gap.inner, uiSize.left.setting.textbox), ...
    'Style', 'edit', ...
    'String', '0.1', ...
    'HorizontalAlignment', 'right', ...
    'Enable', 'off');

uiHandles.left.setting(1,3).text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('lm', uiHandles.left.setting(1,3).textbox, uiSize.const.gap.thin, uiSize.left.setting.text), ...
    'Style', 'text', ...
    'String', 'Tolerance of m/z:', ...
    'HorizontalAlignment', 'left');

%  Create status bar
uiHandles.left.status.icon = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', [ ...
    uiSize.const.gap.outer, ...
    uiSize.const.gap.outer, ...
    uiSize.left.status.icon], ...
    'Style', 'text', ...
    'String', char(9679), ...
    'FontSize', 7.2, ...
    'ForegroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left');

uiHandles.left.status.text = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.left.status.icon, 0, uiSize.left.status.text), ...
    'Style', 'text', ...
    'String', 'Initialized', ...
    'FontSize', 8.5, ...
    'HorizontalAlignment', 'left');

%  Create main buttons
uiHandles.left.main(1,3).back = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('tl', uiHandles.left.status.icon, uiSize.const.gap.inner, uiSize.left.main.halfbutton), ...
    'Style', 'pushbutton', ...
    'String', '< Back', ...
    'Callback', [], ...
    'Enable', 'off');

uiHandles.left.main(1,3).next = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('rb', uiHandles.left.main(1,3).back, uiSize.const.gap.inner, uiSize.left.main.halfbutton), ...
    'Style', 'pushbutton', ...
    'String', 'Next >', ...
    'Callback', [], ...
    'Enable', 'off');

uiHandles.left.main(1,2).button = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('tl', uiHandles.left.main(1,3).back, uiSize.const.gap.inner, uiSize.left.main.button), ...
    'Style', 'pushbutton', ...
    'String', 'Function 2', ...
    'Callback', [], ...
    'Enable', 'off');

uiHandles.left.main(1,1).button = uicontrol(uiHandles.left.panel, ...
    'Units', 'pixels', ...
    'Position', align_object('tl', uiHandles.left.main(1,2).button, uiSize.const.gap.inner, uiSize.left.main.button), ...
    'Style', 'pushbutton', ...
    'String', 'Function 1', ...
    'Callback', [], ...
    'Enable', 'off');

gui_data(uiHandles, [], [], [], [], []);
callback_init([], []);
end



%% 2. Main callback functions
%% 2.1. Initialize callback functions
function callback_init(~, ~, varargin)
%  Description:
%    Initialize the callback functions and the images in UI window. The UI
%    elements needed are turned on.
% ------------------------------------------------------------------------

if nargin == 2
    cat_btn_handles;
    suppress_btn_stat('Initializing...');
else
    suppress_btn_stat('Reversing...');
end

% Reset the colorbar and the main axes
toggle_slider('off');
reset_image_axes;

% Initialize the buttons
update_btn_stat(2, '', @callback_get_mzxml);
update_btn_stat(4, '', @callback_get_marked_image);
update_btn_stat(6, '', @callback_get_raw_image);

update_btn_stat(10, '', [], 'off');
update_btn_stat(11, '', [], 'off');

update_btn_stat(12, '< Back', []);
update_btn_stat(13, 'Next >', @callback_load_files);

update_guide({ ...
    'Welcome to MSI Processor!'; ...
    'This toolbox aims to provide a graphical interface for preprocessing Mass Spectrometry image data. The toolbox consist of three main procedures.'; ...
    '\lt1. Select a m/z value to generate MS image as reference spectra image for image registration.'; ...
    '\lt2. Align the HE stained image with the reference spectra image from Step 1. (The boundary of the HE stained image should be slightly smaller than the reference spectra image for a better extraction accuracy.)'; ...
    '\lt3. Select the color of the boundary lines which are used to highlight the malignant region.'; ...
    'We will lead you through the toolbox with this user guide. If you have any question regarding the toolbox. Please do not hesitate to contact us at Cheng-Chih Hsu Research Group (https://cchlabblog.wordpress.com/).'; ...
    '\bfTo continue, please press the ''Browse'' button to select a folder with mzXML files and a HE stained image with marked boundaries...'});

if nargin == 2
    release_btn_stat('s', 'Standby', [2 4], 12);
else
    release_btn_stat('s', 'Standby', 'r');
end
end

%% 2.1.1. Concatenated button handles
function cat_btn_handles
%  Description:
%    Concatenate the button handles for a better management of the
%    interactive elements. In addition, initialize the appdata.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

uiHandles.cat(1,1) = uiHandles.left.dir(1,1).textbox;
uiHandles.cat(2,1) = uiHandles.left.dir(1,1).button;
uiHandles.cat(3,1) = uiHandles.left.dir(1,2).textbox;
uiHandles.cat(4,1) = uiHandles.left.dir(1,2).button;
uiHandles.cat(5,1) = uiHandles.left.dir(1,3).textbox;
uiHandles.cat(6,1) = uiHandles.left.dir(1,3).button;
uiHandles.cat(7,1) = uiHandles.left.setting(1,1).textbox;
uiHandles.cat(8,1) = uiHandles.left.setting(1,2).textbox;
uiHandles.cat(9,1) = uiHandles.left.setting(1,3).textbox;
uiHandles.cat(10,1) = uiHandles.left.main(1,1).button;
uiHandles.cat(11,1) = uiHandles.left.main(1,2).button;
uiHandles.cat(12,1) = uiHandles.left.main(1,3).back;
uiHandles.cat(13,1) = uiHandles.left.main(1,3).next;
uiHandles.cat(14,1) = uiHandles.mid.setting(1,1).textbox;
uiHandles.cat(15,1) = uiHandles.mid.setting(1,2).textbox;
uiHandles.cat(16,1) = uiHandles.mid.setting(1,3).textbox;

if isappdata(uiHandles.window, 'uiData')
    rmappdata(uiHandles.window, 'uiData');
end
if isappdata(uiHandles.window, 'uiSetting')
    rmappdata(uiHandles.window, 'uiSetting');
end
if isappdata(uiHandles.window, 'uiFlags')
    rmappdata(uiHandles.window, 'uiFlags');
end
set(uiHandles.left.dir(1,1).textbox, 'String', '');
set(uiHandles.left.dir(1,2).textbox, 'String', '');
set(uiHandles.left.dir(1,3).textbox, 'String', '');

gui_data(uiHandles, [], [], [], [], []);
end

%% 2.1.2. Reset the image axes in main figure window
function reset_image_axes
%  Description:
%    Reset the image axes in middle panel with the default color [1 1 1].
% -------------------------------------------------------------------------
[uiHandles, uiSize, ~, ~, ~, uiFlags] = gui_data;

cla(uiHandles.mid.axes);
axes(uiHandles.mid.axes);
uiHandles.mid.image.below = imshow(ones(uiSize.resolution));
hold(uiHandles.mid.axes, 'on');
uiHandles.mid.image.above = imshow(ones(uiSize.resolution));
hold(uiHandles.mid.axes, 'off');
set(uiHandles.mid.image.above, 'AlphaData', 0);
uiFlags.image = false;

gui_data(uiHandles, [], [], [], [], uiFlags);
drawnow;
end


%% 2.2. Load files
function callback_load_files(~, ~, varargin)
%  Description:
%    Load the mzxml files and HE stained images. Then calculate the spectra
%    and show the interactive spectra viewer.
% -------------------------------------------------------------------------
if nargin == 2
    suppress_btn_stat('Loading mzXML files and images...');
else
    suppress_btn_stat('Reversing...');
end
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

status = load_path;
if status
    if nargin == 2
        generate_spectra;
        load_image;
    end
    
    toggle_slider('on');
    update_spectra;
    
    set(uiHandles.window, 'KeyPressFcn', []);
    
    update_btn_stat(12, '', {@callback_init, 'r'})
    update_btn_stat(13, '', @callback_registration)
    
    update_guide({ ...
        'Now, the MS image for a specific m/z value is generated. Please use the slider to browse through the spectra image on different m/z values. Then select a m/z value where the image is clear enough to be used as a reference spectra image. You can also insert a specific m/z value, or use the mouse to scroll through different m/z values.'; ...
        'The bar next to the slider indicates the total intensity of every m/z value. The higher value is indicated in white, while the lower value is indicated in black.'; ...
        '\bfTo proceed to the next step, press the "Next" button...'});
    
    release_btn_stat('s', 'Standby', 12, [1 2 3 4 5 6 7 8 9]);
else
    release_btn_stat('s', 'Standby');
end
end

%% 2.2.1. Load the paths of mzxml and stained images
function status = load_path
%  Description:
%    Load the paths from user inputs and store into uiSetting. If the files
%    are valid, return true.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, uiSetting, ~] = gui_data;

status = false;
if exist(get(uiHandles.left.dir(1,1).textbox, 'String'), 'dir') ...
        && exist(get(uiHandles.left.dir(1,2).textbox, 'String'), 'file')
    uiSetting.folder = get(uiHandles.left.dir(1,1).textbox, 'String');
    uiSetting.imgMarked = get(uiHandles.left.dir(1,2).textbox, 'String');
    uiSetting.imgRaw = get(uiHandles.left.dir(1,3).textbox, 'String');
    uiSetting.mzUpper = str2double(get(uiHandles.left.setting(1,1).textbox, 'String'));
    uiSetting.mzLower = str2double(get(uiHandles.left.setting(1,2).textbox, 'String'));
    uiSetting.tolerance = str2double(get(uiHandles.left.setting(1,3).textbox, 'String'));
    [~, uiSetting.name, ~] = fileparts(uiSetting.folder);
    status = true;
elseif exist(get(uiHandles.left.dir(1,1).textbox, 'String'), 'dir')
    warndlg('Please select a valid marked HE stained image!')
elseif exist(get(uiHandles.left.dir(1,2).textbox, 'String'), 'file')
    warndlg('Please select a valid mzXML folder!')
else
    warndlg('Please select a valid mzXML folder and a valid marked HE stained image!')
end

gui_data([], [], [], [], uiSetting, []);
end

%% 2.2.2. Generate the resampled spectra
function generate_spectra
%  Description:
%    Generate the resampled data and store them into uiData.
% -------------------------------------------------------------------------
[~, uiSize, uiData, ~, uiSetting, ~] = gui_data;

uiData.spectra = [];
list = dir(fullfile(uiSetting.folder, '*.mzXML'));

warning('off','bioinfo:msppresample:TooFewPoints');
prgs = waitbar(0, 'Processing mzXML files...');

for i = size(list, 1):-1:1
    waitbar(1-(i-1)/size(list, 1), prgs, 'Processing mzXML files...');
    
    current = fullfile(uiSetting.folder, list(i).name);
    raw = mzxml2peaks(mzxmlread(current, 'verbose', false), 'level', 1);
    
    if i ~= size(list, 1)
        if size(raw, 1) < size(uiData.spectra, 2)
            uiData.spectra = uiData.spectra(:,1:size(raw, 1),:);
        elseif size(raw, 1) > size(uiData.spectra, 2)
            raw = raw(1:size(uiData.spectra, 2),:);
        end
    end
    
    for j = 1:size(raw, 1)
        raw{j,1} = [uiSetting.mzLower 0; raw{j,1}; uiSetting.mzUpper 0];
        [uiData.mzInterval, uiData.spectra(:,j,i)] = msppresample(raw{j,1}, ...
            (uiSetting.mzUpper-uiSetting.mzLower)/uiSetting.tolerance+1, ...
            'range',[uiSetting.mzLower uiSetting.mzUpper]);
    end
end

close(prgs);
uiData.spectra = permute(uiData.spectra, [2 3 1]);
uiData.spectra = flip(flip(uiData.spectra, 1), 2);

uiSize.dynamic.spectra.original = [size(uiData.spectra, 1), size(uiData.spectra, 2)];
[~, uiSize.dynamic.direction] = max(uiSize.dynamic.spectra.original);

gui_data([], uiSize, uiData, [], [], []);
end

%% 2.2.3. Load the stained images
function load_image
[~, uiSize, ~, uiImage, uiSetting, ~] = gui_data;

uiImage.marked.original = imread(uiSetting.imgMarked);
uiImage.marked.resized = resize_image(uiImage.marked.original);
uiSize.dynamic.marked.original = [size(uiImage.marked.original, 1) size(uiImage.marked.original, 2)];
uiSize.dynamic.marked.resized = [size(uiImage.marked.resized, 1) size(uiImage.marked.resized, 2)];
try
    uiImage.raw.original = imread(uiSetting.imgRaw);
    uiImage.raw.resized = resize_image(uiImage.raw.original);
    uiSize.dynamic.raw.original = [size(uiImage.raw.original, 1) size(uiImage.raw.original, 2)];
    uiSize.dynamic.raw.resized = [size(uiImage.raw.resized, 1) size(uiImage.raw.resized, 2)];
catch
    if isfield(uiSize.dynamic, 'raw')
        uiSize.dynamic = rmfield(uiSize.dynamic, 'raw');
    end
end

gui_data([], uiSize, [], uiImage, uiSetting, []);
end


%% 2.3 Start the image registration
function callback_registration(~, ~, varargin)
%  Description:
%    Start the image registration process. Enable the keyboard input for
%    the user to move the image.
% -------------------------------------------------------------------------
if nargin == 2
    suppress_btn_stat('Transforming images...');
else
    suppress_btn_stat('Reversing...');
end
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

if nargin == 2
    init_transform;
end
apply_transform;

update_spectra('bw');
toggle_slider('off');

setappdata(uiHandles.window, 'interactFlag', true);
set(uiHandles.window, 'KeyPressFcn', @callback_alignment);

update_btn_stat(12, '', {@callback_load_files, 'r'})
update_btn_stat(13, '', @callback_confirm)

update_guide({ ...
    'Here, please use the keyboard to adjust the position of the HE stained image. The HE stained image should be aligned with the reference spectra image. The boundary of the HE stained image should be slightly within the boundary of the reference spectra image. By doing this, the selection of the background signal can be prevented.'; ...
    'The step size of translation, rotation, or scaling can be set below the figure.'; ...
    '\bfTo proceed to the next step, press the "Next" button...'}, ...
    'k');

if nargin == 2
    release_btn_stat('i', 'Use the keyboard to move the image...', [14 15 16], []);
else
    release_btn_stat('i', 'Use the keyboard to move the image...', 'r');
end
end

%% 2.3.1. Initialize the tranformation martrix of the image
function init_transform
%  Description:
%    Initialize the transformation matrix of the stained image.
% -------------------------------------------------------------------------
[~, uiSize, ~, ~, uiSetting, uiFlags] = gui_data;

uiSetting.transform.value.translate = [0 0];
uiSetting.transform.value.scale = [1 1];
uiSetting.transform.value.rotate = 0;
uiSetting.transform.matrix.original = eye(3);
switch uiSize.dynamic.direction
    case 1
        uiSetting.transform.matrix.original(3,1) = (uiSize.dynamic.spectra.resized(1,2)-uiSize.dynamic.marked.resized(1,2))/2;
    case 2
        uiSetting.transform.matrix.original(3,2) = (uiSize.dynamic.spectra.resized(1,1)-uiSize.dynamic.marked.resized(1,1))/2;
end
uiFlags.interact = true;

gui_data([], [], [], [], uiSetting, uiFlags);
end


%% 2.4 Confirm the registration of the image
function callback_confirm(~, ~, varargin)
%  Description:
%    Confirm the image registration and process the original images base on
%    the transformation matrix.
% -------------------------------------------------------------------------
if nargin == 2
    suppress_btn_stat('Processing images...');
else
    suppress_btn_stat('Reversing...');
end
[uiHandles, uiSize, ~, ~, ~, ~] = gui_data;

process_image;

set(uiHandles.window, 'KeyPressFcn', []);
if isfield(uiHandles, 'magnifier')
    structfun(@delete, uiHandles.magnifier);
end

set(uiHandles.window, ...
    'WindowButtonMotionFcn',[], ...
    'WindowButtonDownFcn',[]);

update_btn_stat(10, 'Save raw HE stained image', ...
    @callback_save_raw_image, 'on');
update_btn_stat(11, 'Save marked HE stained image', ...
    @callback_save_marked_image, 'on');

update_btn_stat(12, '', {@callback_registration, 'r'})
update_btn_stat(13, '', @callback_selection)

if isfield(uiSize.dynamic, 'raw')
    update_guide({ ...
        'Now, the HE stained image were registered and were ready for the next step. The raw HE stained image was automatically registered with the marked HE stained image. Before continuing, please check if both the images are correctly aligned. If the two images are not aligned correctly, please run the toolbox without raw HE stained image, or use another image.'; ...
        'In addition, you can save the registered image for other applications or future use. The image can be save in different extensions such as jpg, png, or tiff files.'; ...
        '\bfTo proceed to the next step, press the "Next" button...'});
else
    update_guide({ ...
        'Now, the HE stained image were registered and were ready for the next step.'; ...
        'You can save the registered image for other applications or future use. The image can be save in different extensions such as jpg, png, or tiff files.'; ...
        '\bfTo proceed to the next step, press the "Next" button...'});
end

if nargin == 2
    if isfield(uiSize.dynamic, 'raw')
        release_btn_stat('s', 'Standby', [10 11], []);
    else
        release_btn_stat('s', 'Standby', 11, 10);
    end
else
    release_btn_stat('s', 'Standby', 'r');
end
end

%% 2.4.1. Process original images
function process_image
%  Description:
%    Process the original images base on the transformation matrix. Then
%    update the images shown on the main figure axes.
% -------------------------------------------------------------------------
[~, ~, ~, uiImage, ~, ~] = gui_data;

uiImage.marked.transform = transform_image(uiImage.marked.original);
if isfield(uiImage, 'raw')
    gMarkedImg = rgb2gray(uiImage.marked.original);
    gRawImg = rgb2gray(uiImage.raw.original);
    
    ptsMarked = detectSURFFeatures(gMarkedImg);
    ptsRaw = detectSURFFeatures(gRawImg);
    [featuresMarked, validPtsMarked]  = extractFeatures(gMarkedImg, ptsMarked);
    [featuresRaw, validPtsRaw]  = extractFeatures(gRawImg, ptsRaw);
    
    indexPairs = matchFeatures(featuresMarked, featuresRaw);
    
    matchedMarked = validPtsMarked(indexPairs(:,1));
    matchedRaw = validPtsRaw(indexPairs(:,2));
    
    [tform, ~, ~] = estimateGeometricTransform(...
        matchedRaw, matchedMarked, 'similarity');
    outputView = imref2d(size(gMarkedImg));
    registeredRaw  = imwarp(uiImage.raw.original,tform, 'nearest', 'FillValues', 255,'OutputView',outputView);
    uiImage.raw.transform = transform_image(registeredRaw);
    update_image(resize_image(uiImage.marked.transform, 'fit'), resize_image(uiImage.raw.transform, 'fit'), 0.5);
else
    update_image(resize_image(uiImage.marked.transform, 'fit'), [], 0);
end

gui_data([], [], [], uiImage, [], []);
end


%% 2.5. Start boundary selection
function callback_selection(~, ~, varargin)
%  Description:
%    Start the selection tool of boundary selection.
% -------------------------------------------------------------------------
if nargin == 2
    suppress_btn_stat('Initializing selection tool...');
else
    suppress_btn_stat('Reversing...');
end
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

init_magnifier;

set(uiHandles.window, ...
    'WindowButtonMotionFcn',@callback_hover, ...
    'WindowButtonDownFcn',@callback_click);

update_btn_stat(10, '', [], 'off');
update_btn_stat(11, '', [], 'off');

update_btn_stat(12, '', {@callback_confirm, 'r'})
update_btn_stat(13, 'Next >', @callback_final)

update_guide({ ...
    'Here, please select the color of the boundaries of the region of interest. The selected color is showed in the upper-left corner of the main figure window. The regions which are marked by the boundaries can be see on the figure with the color of the lines. Please try to select through different parts of the lines until all boundaries are marked.'; ...
    'Note that broken lines will cause errors while marking boundaries. To solve the problem, please use softwares such as mspaint to close the gap with the same color. In addition, The color of the tissue is assumed purple by default.'; ...
    '\bfTo proceed to the next step, press the "Next" button...'});

if nargin == 2
    release_btn_stat('i', 'Select the boundary on the image...', [], [10 11]);
else
    release_btn_stat('i', 'Select the boundary on the image...', 'r');
end
end

%% 2.5.1. Initialize magnifier
function init_magnifier
%  Description:
%    Initialize the magnifier window on the main figure axes.
% -------------------------------------------------------------------------
[uiHandles, uiSize, ~, uiImage, ~, ~] = gui_data;

magnification = 9;
colorWidth = 1/4*uiSize.const.magnifier;
colorGap = 5;
crossLength = 1/3*uiSize.const.magnifier;
crossWidth = 2;

update_image([], [], 0);

axes(uiHandles.mid.magnifier.axes);
uiHandles.magnifier.image = imshow(0.5*ones(uiSize.const.magnifier));
hold(uiHandles.mid.magnifier.axes, 'on');
uiHandles.magnifier.crossbar(1,1) = fill(uiSize.const.magnifier/2*[1 1 1 1]+crossLength/2*[1 -1 -1 1], ...
    uiSize.const.magnifier/2*[1 1 1 1]+crossWidth/2*[1 1 -1 -1], ...
    [1 0 0], 'LineStyle','none');
uiHandles.magnifier.crossbar(1,2) = fill(uiSize.const.magnifier/2*[1 1 1 1]+crossWidth/2*[1 1 -1 -1], ...
    uiSize.const.magnifier/2*[1 1 1 1]+crossLength/2*[1 -1 -1 1], ...
    [1 0 0], 'LineStyle','none');

uiHandles.magnifier.color(1,1) = fill((colorWidth+colorGap)*[0 1 0], ...
    (colorWidth+colorGap)*[0 0 1], ...
    0.94*ones(1,3), 'LineStyle','none');
uiHandles.magnifier.color(1,2) = fill( ...
    colorWidth*[0 1 0], ...
    colorWidth*[0 0 1], ...
    0.4*ones(1,3), 'LineStyle','none');
hold(uiHandles.mid.magnifier.axes, 'off');

magnifier.image = uiHandles.magnifier.image;
magnifier.color = uiHandles.magnifier.color(1,2);

magnifiedImg = imresize(uiImage.marked.transform, ...
    magnification*uiSize.dynamic.spectra.resized(1,1)/size(uiImage.marked.transform, 1), 'nearest');

magnifier.tolerance = 60;
magnifier.window = uiSize.const.magnifier;
magnifier.xRange = [0 uiSize.dynamic.spectra.resized(1,2)];
magnifier.yRange = [0 uiSize.dynamic.spectra.resized(1,1)];
magnifier.xScale = size(magnifiedImg, 2)/uiSize.dynamic.spectra.resized(1,2);
magnifier.yScale = size(magnifiedImg, 1)/uiSize.dynamic.spectra.resized(1,1);
magnifier.source = uint8(240*ones(size(magnifiedImg, 1)+uiSize.const.magnifier, ...
    size(magnifiedImg, 2)+uiSize.const.magnifier, 3));
magnifier.source((uiSize.const.magnifier/2+1):(end-uiSize.const.magnifier/2), ...
    (uiSize.const.magnifier/2+1):(end-uiSize.const.magnifier/2), :) = magnifiedImg;

setappdata(uiHandles.window, 'magnifier', magnifier);
gui_data(uiHandles, [], [], [], [], []);
end


%% 2.6. Final processing
function callback_final(~, ~, varargin)
%  Description:
%    Extract the spectra from the mask selected and add the label to the
%    dataset.
% -------------------------------------------------------------------------
if nargin == 2
    suppress_btn_stat('Extracting spectra...');
else
    suppress_btn_stat('Reversing...');
end
[uiHandles, ~, ~, uiImage, ~, ~] = gui_data;

if isfield(uiImage, 'mask')
    extract_spectra;
    
    if isfield(uiHandles, 'magnifier')
        structfun(@delete, uiHandles.magnifier);
    end
    
    set(uiHandles.window, ...
        'WindowButtonMotionFcn',[], ...
        'WindowButtonDownFcn',[]);
    
    update_btn_stat(11, 'Save extracted spectra', ...
        @callback_save_spectra, 'on');
    
    update_btn_stat(12, '', {@callback_selection, 'r'})
    update_btn_stat(13, 'Finish >', @callback_init)
    
    update_guide({ ...
        'Finally, the regions of both benign and malignant are generated, and the spectra are extracted. The malignant region is colored in red, and the benign region is colored in blue. The extracted spectra are available in two different formats.'; ...
        '\bf- Excel file (.xlsx)'; ...
        '\idThe file contains a header with the first two column set to Label and ID. The other columns conatines intensities from different m/z values.'; ...
        '\bf- Matlab file (.mat)'; ...
        '\idThe file containes three variables mask, data, and index. "mask" contains the binary region of both malignant and benign region. "data" contains both the extracted spectra. "index" contains the index of the spectra on the original image.'; ...
        '\bfTo restart the processor, press the "Finish" button...'});
    
    if nargin == 2
        release_btn_stat('s', 'Standby', 11);
    else
        release_btn_stat('s', 'Standby', 'r');
    end
else
    release_btn_stat('s', 'Standby');
end

end

%% 2.6.1. Extract spectra
function extract_spectra
%  Description:
%    Extract the spectra from the mask and show the separation between two
%    classes.
% -------------------------------------------------------------------------
[~, uiSize, uiData, uiImage, uiSetting, ~] = gui_data;
if isfield(uiImage, 'raw')
    tissueMask = uiImage.raw.transform(:,:,2) < 150;
else
    tissueMask = uiImage.marked.transform(:,:,2) < 150+uiImage.boundary.original;
end
malignantMask = uiImage.mask.original;

rstissueMask = imresize(tissueMask, uiSize.dynamic.spectra.original);
rsMalignantMask = imresize(malignantMask, uiSize.dynamic.spectra.original);
rsMalignantMask = rstissueMask & rsMalignantMask;
rsBenignMask = rstissueMask & ~rsMalignantMask;

reshapedMalignant = reshape(rsMalignantMask, size(rsMalignantMask, 1)*size(rsMalignantMask, 2), []);
reshapedBenign = reshape(rsBenignMask, size(rsBenignMask, 1)*size(rsBenignMask, 2), []);
reshapedSpectra = reshape(uiData.spectra, prod(uiSize.dynamic.spectra.original), []);

idxMalignant = find(reshapedMalignant);
idxBenign = find(reshapedBenign);

uiData.data.malignant = reshapedSpectra(reshapedMalignant, :);
uiData.data.benign = reshapedSpectra(reshapedBenign, :);
uiData.data.mzInterval = uiData.mzInterval;
uiData.mask.malignant = rsMalignantMask;
uiData.mask.benign = rsBenignMask;
uiData.index.malignant = idxMalignant;
uiData.index.benign = idxBenign;

uiData.xlsx = [{'Label'}, {'ID'}, num2cell(uiData.mzInterval')];
uiData.xlsx = [uiData.xlsx; [repmat([{'Malignant'}, {uiSetting.name}], size(uiData.data.malignant, 1), 1), num2cell(uiData.data.malignant)]];
uiData.xlsx = [uiData.xlsx; [repmat([{'Benign'}, {uiSetting.name}], size(uiData.data.benign, 1), 1), num2cell(uiData.data.benign)]];

combinedMask = resize_image(0.7*cat(3, uiData.mask.malignant, zeros(size(uiData.mask.malignant)), uiData.mask.benign), 'fit');
alphaMask = resize_image(uiData.mask.malignant+uiData.mask.benign, 'fit');

gui_data([], [], uiData, [], [], []);
update_image([], combinedMask, 0.5*alphaMask);
end





%% Callback functions
%  ========================================================================
%  Here are the callback functions of different UI elements.

%% Callback function for getting the path to the directory
function callback_get_mzxml(~, ~)
%  Description:
%    The callback function to generate interacive window for the user to
%    input the path to the directory that containes mzXML files.
% -------------------------------------------------------------------------
suppress_btn_stat('Selecting mzXML folder...');
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

if isdeployed
    dirPath = uigetdir('C:\', 'Select the folder containing mzXML files');
else
    dirPath = uigetdir('..\', 'Select the folder containing mzXML files');
end
if dirPath
    set(uiHandles.left.dir(1,1).textbox, 'String', dirPath);
    
    update_guide({ ...
        'Here are the folder, files, and settings you can select.'; ...
        '\bf- Folder of mzXML files (mandatory):'; ...
        '\idThe folder which contains all the mzXML files for this sample. Each mzXML file in the folder should be a scan on the sample.'; ...
        '\bf- Marked HE stained image (mandatory):'; ...
        '\idThe HE stained image with the region of interest circled by lines with fixed color. This image will be used to extract the spectra later on.'; ...
        '\bf- Raw HE stained image (optional):'; ...
        '\idThe HE stained image without any mark or highlight. The use of raw HE stained image increases the accuracy of extracting the spectra.'; ...
        '\bf- Upper and lower m/z boundary:'; ...
        '\idThe range of the m/z value to be extract. Smaller range will result in a smaller data size. The range should be dividable by the tolerance.'; ...
        '\bf- Tolerance of m/z:'; ...
        '\idThe bin size of m/z value while resampling the original spectra. Smaller tolerance will result in oversampling.'; ...
        '\bfTo proceed to the next step, press the "Next" button...'});
    
    if ~isempty(get(uiHandles.left.dir(1,2).textbox, 'String'))
        release_btn_stat('s', 'Standby', [6 7 8 9 13], []);
    else
        release_btn_stat('s', 'Standby', [], [6 7 8 9 13]);
    end
else
    set(uiHandles.left.dir(1,1).textbox, 'String', '');
    release_btn_stat('s', 'Standby', [], [6 7 8 9 13]);
end
drawnow;
pause(0.05);
end

%% Callback function for getting the marked HE stained image
function callback_get_marked_image(~, ~)
%  Description:
%    The callback function to generate interacive window for the user to
%    input the path to the marked HE stained image.
% -------------------------------------------------------------------------
suppress_btn_stat('Selecting marked HE stained image...');
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

[fileName, filePath] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.tiff;*.bmp', 'Image file (*.jpg,*.jpeg,*.png,*.tiff,*.bmp)'; ...
    '*.*',  'All Files (*.*)'}, 'Select marked HE stained image', get(uiHandles.left.dir(1,1).textbox, 'String'));
if filePath
    set(uiHandles.left.dir(1,2).textbox, 'String', [filePath,fileName]);
    
    update_guide({ ...
        'Here are the folder, files, and settings you can select.'; ...
        '\bf- Folder of mzXML files (mandatory):'; ...
        '\idThe folder which contains all the mzXML files for this sample. Each mzXML file in the folder should be a scan on the sample.'; ...
        '\bf- Marked HE stained image (mandatory):'; ...
        '\idThe HE stained image with the region of interest circled by lines with fixed color. This image will be used to extract the spectra later on.'; ...
        '\bf- Raw HE stained image (optional):'; ...
        '\idThe HE stained image without any mark or highlight. The use of raw HE stained image increases the accuracy of extracting the spectra.'; ...
        '\bf- Upper and lower m/z boundary:'; ...
        '\idThe range of the m/z value to be extract. Smaller range will result in a smaller data size. The range should be dividable by the tolerance.'; ...
        '\bf- Tolerance of m/z:'; ...
        '\idThe bin size of m/z value while resampling the original spectra. Smaller tolerance will result in oversampling.'; ...
        '\bfTo proceed to the next step, press the "Next" button...'});
    
    if ~isempty(get(uiHandles.left.dir(1,1).textbox, 'String'))
        release_btn_stat('s', 'Standby', [6 7 8 9 13], []);
    else
        release_btn_stat('s', 'Standby', [], [6 7 8 9 13]);
    end
else
    set(uiHandles.left.dir(1,2).textbox, 'String', '');
    release_btn_stat('s', 'Standby', [], [6 7 8 9 13]);
end
drawnow;
pause(0.05);
end

%% Callback function for getting the raw HE stained image
function callback_get_raw_image(~, ~)
%  Description:
%    The callback function to generate interacive window for the user to
%    input the path to the raw HE stained image.
% -------------------------------------------------------------------------
suppress_btn_stat('Selecting raw HE stained image...');
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

[fileName, filePath] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.tiff;*.bmp', 'Image file (*.jpg,*.jpeg,*.png,*.tiff,*.bmp)'; ...
    '*.*',  'All Files (*.*)'}, 'Select raw HE stained image', get(uiHandles.left.dir(1,1).textbox, 'String'));
if filePath
    set(uiHandles.left.dir(1,3).textbox, 'String', [filePath,fileName]);
else
    set(uiHandles.left.dir(1,3).textbox, 'String', '');
end
release_btn_stat('s', 'Standby');
drawnow;
pause(0.05);
end

%% Callback function for the middle slider
function callback_slider(src, ~)
%  Description:
%    Callback function of the middle slider to check the input value. Then
%    update the spectra image base on the value.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, uiSetting, ~] = gui_data;

splt = regexp(num2str(uiSetting.tolerance), '\.', 'split');
if size(splt, 2) == 2
    dps = size(splt{2}, 2);
else
    dps = 0;
end
mzTarget = round(src.Value, dps);
set(src, 'Value', mzTarget);
set(uiHandles.mid.scroll.textbox, 'String', mzTarget);

update_spectra;
end

%% Callback function for the middle slider textbox
function callback_slider_textbox(src, ~)
%  Description:
%    Callback function of the middle slider textbox to check the input
%    value. Then update the spectra image base on the value.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, uiSetting, ~] = gui_data;

if ~isnan(str2double(get(src, 'String')))
    splt = regexp(num2str(uiSetting.tolerance), '\.', 'split');
    if size(splt, 2) == 2
        dps = size(splt{2}, 2);
    else
        dps = 0;
    end
    mzTarget = round(str2double(get(src, 'String')), dps);
    if mzTarget > uiSetting.mzUpper
        mzTarget = uiSetting.mzUpper;
    elseif mzTarget < uiSetting.mzLower
        mzTarget = uiSetting.mzLower;
    end
else
    mzTarget = get(uiHandles.mid.scroll.slider, 'Value');
end
set(uiHandles.mid.scroll.slider, 'Value', mzTarget);
set(uiHandles.mid.scroll.textbox, 'String', mzTarget);

update_spectra;
end

%% Callback function for the mouse scroll
function callback_scroll(~, scroll)
%  Description:
%    Callback function of the mouse scroll to check the input value. Then
%    update the spectra image base on the value.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, uiSetting, ~] = gui_data;

increment = uiSetting.tolerance*scroll.VerticalScrollCount;
mzTarget = get(uiHandles.mid.scroll.slider, 'Value');
mzTarget = mzTarget-increment;
if mzTarget > uiSetting.mzUpper
    mzTarget = uiSetting.mzUpper;
elseif mzTarget < uiSetting.mzLower
    mzTarget = uiSetting.mzLower;
end
set(uiHandles.mid.scroll.slider, 'Value', mzTarget);
set(uiHandles.mid.scroll.textbox, 'String', mzTarget);

update_spectra;
end

%% Callback function for image registration
function callback_alignment(~, event)
%  Description:
%    The callback function for listening keyboard inputs from the user and
%    apply transformation to the image based on the stored matrix.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, uiSetting, ~] = gui_data;

switch event.Key
    case 'w'
        uiSetting.transform.value.translate = uiSetting.transform.value.translate+[0 -str2double(get(uiHandles.mid.setting(1,1).textbox, 'String'))];
    case 's'
        uiSetting.transform.value.translate = uiSetting.transform.value.translate+[0 str2double(get(uiHandles.mid.setting(1,1).textbox, 'String'))];
    case 'a'
        uiSetting.transform.value.translate = uiSetting.transform.value.translate+[-str2double(get(uiHandles.mid.setting(1,1).textbox, 'String')) 0];
    case 'd'
        uiSetting.transform.value.translate = uiSetting.transform.value.translate+[str2double(get(uiHandles.mid.setting(1,1).textbox, 'String')) 0];
    case 'q'
        uiSetting.transform.value.rotate = uiSetting.transform.value.rotate+str2double(get(uiHandles.mid.setting(1,2).textbox, 'String'));
    case 'e'
        uiSetting.transform.value.rotate = uiSetting.transform.value.rotate-str2double(get(uiHandles.mid.setting(1,2).textbox, 'String'));
    case 'i'
        uiSetting.transform.value.scale = uiSetting.transform.value.scale+[0 str2double(get(uiHandles.mid.setting(1,3).textbox, 'String'))];
    case 'k'
        uiSetting.transform.value.scale = uiSetting.transform.value.scale+[0 -str2double(get(uiHandles.mid.setting(1,3).textbox, 'String'))];
    case 'j'
        uiSetting.transform.value.scale = uiSetting.transform.value.scale+[-str2double(get(uiHandles.mid.setting(1,3).textbox, 'String')) 0];
    case 'l'
        uiSetting.transform.value.scale = uiSetting.transform.value.scale+[str2double(get(uiHandles.mid.setting(1,3).textbox, 'String')) 0];
    case 'o'
        uiSetting.transform.value.scale = uiSetting.transform.value.scale+str2double(get(uiHandles.mid.setting(1,3).textbox, 'String'))*[1 1];
    case 'u'
        uiSetting.transform.value.scale = uiSetting.transform.value.scale-str2double(get(uiHandles.mid.setting(1,3).textbox, 'String'))*[1 1];
end
gui_data([], [], [], [], uiSetting, []);

if getappdata(uiHandles.window, 'interactFlag')
    setappdata(uiHandles.window, 'interactFlag', false);
    apply_transform;
    setappdata(uiHandles.window, 'interactFlag', true);
end
end

%% Callback function for saving the marked HE stained image
function callback_save_marked_image(~, ~)
%  Description:
%    The callback function to generate interacive window for the user to
%    input the path to save the marked HE stained image.
% -------------------------------------------------------------------------
suppress_btn_stat('Saving registered marked image...');
[~, ~, ~, uiImage, ~, ~] = gui_data;

[nameMarkedFile, nameMarkedDir] = uiputfile({...
    '*.jpg', 'JPEG file (*.jpg)'; ...
    '*.png', 'PNG file (*.png)'; ...
    '*.tiff', 'TIFF file (*.tiff)'}, ...
    'Save the registered HE stained image (Marked)', ...
    'markedRegisteredImage.jpg');
if nameMarkedFile ~= 0
    imwrite(uiImage.marked.transform, [nameMarkedDir, nameMarkedFile]);
end
release_btn_stat('s', 'Standby');
end

%% Callback function for saving the raw HE stained image
function callback_save_raw_image(~, ~)
%  Description:
%    The callback function to generate interacive window for the user to
%    input the path to save the raw HE stained image.
% -------------------------------------------------------------------------
suppress_btn_stat('Saving registered raw image...');
[~, ~, ~, uiImage, ~, ~] = gui_data;

[nameMarkedFile, nameMarkedDir] = uiputfile({...
    '*.jpg', 'JPEG file (*.jpg)'; ...
    '*.png', 'PNG file (*.png)'; ...
    '*.tiff', 'TIFF file (*.tiff)'}, ...
    'Save the registered HE stained image (Raw)', ...
    'rawRegisteredImage.jpg');
if nameMarkedFile ~= 0
    imwrite(uiImage.raw.transform, [nameMarkedDir, nameMarkedFile]);
end
release_btn_stat('s', 'Standby');
end

%% Callback function for mouse hover on magnifier
function callback_hover(~, ~)
%  Description:
%    The callback function to check the mouse position and update the
%    magnifier image.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, ~] = gui_data;
magnifier = getappdata(uiHandles.window, 'magnifier');

currentPoint = uiHandles.mid.axes.CurrentPoint;
x = currentPoint(2,1)-0.5;
y = currentPoint(2,2)-0.5;

if (x >= magnifier.xRange(1,1) && x <= magnifier.xRange(1,2)) && (y >= magnifier.yRange(1,1) && y <= magnifier.yRange(1,2))
    set(uiHandles.window, 'Pointer', 'crosshair');
    insideFlag = true;
else
    set(uiHandles.window, 'Pointer', 'arrow');
    insideFlag = false;
end

if x < magnifier.xRange(1,1)
    x = magnifier.xRange(1,1);
elseif x > magnifier.xRange(1,2)
    x = magnifier.xRange(1,2);
end
if y < magnifier.yRange(1,1)
    y = magnifier.yRange(1,1);
elseif y > magnifier.yRange(1,2)
    y = magnifier.yRange(1,2);
end

padX = round(x*magnifier.xScale)+magnifier.window/2;
padY = round(y*magnifier.yScale)+magnifier.window/2;
extractedImg = magnifier.source( ...
    (padY-magnifier.window/2+1):(padY+magnifier.window/2), ...
    (padX-magnifier.window/2+1):(padX+magnifier.window/2), :);
magnifier.image.CData = extractedImg;
drawnow;
if insideFlag == true
    magnifier.current = double(squeeze(magnifier.source(padY, padX, :)))'/255;
end

setappdata(uiHandles.window, 'insideFlag', insideFlag);
setappdata(uiHandles.window, 'magnifier', magnifier);
end

%% Callback function for mouse click on magnifier
function callback_click(src, ~)
%  Description:
%    The callback function to check the mouse position and update the
%    magnifier color.
% -------------------------------------------------------------------------
[uiHandles, uiSize, ~, uiImage, ~, ~] = gui_data;

if strcmp(src.SelectionType, 'normal') && getappdata(uiHandles.window, 'insideFlag')
    magnifier = getappdata(uiHandles.window, 'magnifier');
    
    [uiImage.mask.original, uiImage.boundary.original] = ...
        generate_mask(uiImage.marked.transform, ...
        magnifier.current, magnifier.tolerance);
    uiImage.mask.resized = resize_image(uiImage.mask.original, 'fit');
    
    uiImage.boundary.resized = resize_image(uiImage.boundary.original, 'fit');
    
    update_image([], ...
        ind2rgb(ones(uiSize.dynamic.spectra.resized), [1 0 0]), ...
        0.8*double(uiImage.mask.resized));
    set(magnifier.color, 'FaceColor', magnifier.current);
    pause(0.3);
    update_image([], ...
        ind2rgb(ones(uiSize.dynamic.spectra.resized), magnifier.current), ...
        0.5*double(uiImage.mask.resized));
    gui_data([], uiSize, [], uiImage, [], []);
end
end

%% Callback function for saving the extracted spectra
function callback_save_spectra(~, ~)
%  Description:
%    The callback function to add label and ID to data and let the user to
%    select the path for saving.
% -------------------------------------------------------------------------
suppress_btn_stat('Saving extracted spectra...');
[~, ~, uiData, ~, uiSetting, ~] = gui_data;

data = uiData.data;
mask = uiData.mask;
index = uiData.index;
xlsx = uiData.xlsx;

[nameFile, nameDir] = uiputfile({...
    '*.xlsx', 'Excel file (*.xlsx)'; ...
    '*.mat', 'Matlab file (*.mat)'}, ...
    'Save extracted spectra', ...
    fullfile(uiSetting.folder, 'extractedSpectra.xlsx'));
if nameFile ~= 0
    [~, ~, extension] = fileparts(nameFile);
    if strcmp(extension, '.xlsx')
        xlswrite(fullfile(nameDir, nameFile), xlsx);
    elseif strcmp(extension, '.mat')
        save(fullfile(nameDir, nameFile), 'mask', 'data', 'index');
    end
end

release_btn_stat('s', 'Standby');
end





%% General functions
%  ========================================================================
%  Here are the functions that are called multiple times. These functions
%  are used by several other functions.

%% I/O related
%% Store and retrieve data
%  [uiHandles, uiSize, uiData, uiImage, uiSetting, uiFlags] = gui_data;
%  gui_data(uiHandles, uiSize, uiData, uiImage, uiSetting, uiFlags);
function varargout = gui_data(varargin)
%  Description:
%    Store or retrieve the stored data from UI interface. Replace the not
%    used variables with ~ while retrieving and [] while storing.
% -------------------------------------------------------------------------
%  -Retrieve:
%    [uiHandles, uiSize, uiData, uiImage, uiSetting, uiFlags] = gui_data;
%  -Store:
%    gui_data(uiHandles, uiSize, uiData, uiImage, uiSetting, uiFlags);
% -------------------------------------------------------------------------
currentFig = gcf;
if strcmp(get(currentFig, 'Tag'), 'msiProcessor')
    if nargin == 6
        if ~isempty(varargin{1})
            setappdata(currentFig, 'uiHandles', varargin{1});
        end
        if ~isempty(varargin{2})
            setappdata(currentFig, 'uiSize', varargin{2});
        end
        if ~isempty(varargin{3})
            setappdata(currentFig, 'uiData', varargin{3});
        end
        if ~isempty(varargin{4})
            setappdata(currentFig, 'uiImage', varargin{4});
        end
        if ~isempty(varargin{5})
            setappdata(currentFig, 'uiSetting', varargin{5});
        end
        if ~isempty(varargin{6})
            setappdata(currentFig, 'uiFlags', varargin{6});
        end
    elseif nargout == 6
        if isappdata(currentFig, 'uiHandles')
            varargout{1} = getappdata(currentFig, 'uiHandles');
        else
            varargout{1} = [];
        end
        if isappdata(currentFig, 'uiSize')
            varargout{2} = getappdata(currentFig, 'uiSize');
        else
            varargout{2} = [];
        end
        if isappdata(currentFig, 'uiData')
            varargout{3} = getappdata(currentFig, 'uiData');
        else
            varargout{3} = [];
        end
        if isappdata(currentFig, 'uiImage')
            varargout{4} = getappdata(currentFig, 'uiImage');
        else
            varargout{4} = [];
        end
        if isappdata(currentFig, 'uiSetting')
            varargout{5} = getappdata(currentFig, 'uiSetting');
        else
            varargout{5} = [];
        end
        if isappdata(currentFig, 'uiFlags')
            varargout{6} = getappdata(currentFig, 'uiFlags');
        else
            varargout{6} = [];
        end
    else
        error('Wrong number of I/O in gui_data');
    end
else
    error('Couldn''t detect msiProcessor.')
end
end


%% UI elements related
%% Calculate relative position of objects
%  position = align_object('r/l/b/t+r/l/b/t/m', refObject, 5, [15 20]);
function position = align_object(alignment, refObject, gap, currentSize)
%  Description:
%    Calculate the relative position of the objects.
% -------------------------------------------------------------------------
%  -Alignment:
%
%      'tl'  'tm'  'tr'
%   'lt' ------------ 'rt'
%       |            |
%   'lm'|  Reference |'rm'
%       |            |
%   'lb' ------------ 'rb'
%      'bl'  'bm'  'br'
%
% -------------------------------------------------------------------------
if alignment(1) == 'r'
    x = refObject.Position(1,1)+refObject.Position(1,3)+gap;
    if alignment(2) == 'b'
        y = refObject.Position(1,2);
    elseif alignment(2) == 'm'
        y = refObject.Position(1,2)+(refObject.Position(1,4)-currentSize(1,2))/2;
    elseif alignment(2) == 't'
        y = refObject.Position(1,2)+refObject.Position(1,4)-currentSize(1,2);
    end
elseif alignment(1) == 'b'
    y = refObject.Position(1,2)-currentSize(1,2)-gap;
    if alignment(2) == 'l'
        x = refObject.Position(1,1);
    elseif alignment(2) == 'm'
        x = refObject.Position(1,1)+(refObject.Position(1,3)-currentSize(1,1))/2;
    elseif alignment(2) == 'r'
        x = refObject.Position(1,1)+refObject.Position(1,3)-currentSize(1,1);
    end
elseif alignment(1) == 'l'
    x = refObject.Position(1,1)-currentSize(1,1)-gap;
    if alignment(2) == 'b'
        y = refObject.Position(1,2);
    elseif alignment(2) == 'm'
        y = refObject.Position(1,2)+(refObject.Position(1,4)-currentSize(1,2))/2;
    elseif alignment(2) == 't'
        y = refObject.Position(1,2)+refObject.Position(1,4)-currentSize(1,2);
    end
elseif alignment(1) == 't'
    y = refObject.Position(1,2)+refObject.Position(1,4)+gap;
    if alignment(2) == 'l'
        x = refObject.Position(1,1);
    elseif alignment(2) == 'm'
        x = refObject.Position(1,1)+(refObject.Position(1,3)-currentSize(1,1))/2;
    elseif alignment(2) == 'r'
        x = refObject.Position(1,1)+refObject.Position(1,3)-currentSize(1,1);
    end
end
position = [x y currentSize];
end

%% Change current status
%  update_status('b'/'i'/'s', 'some text');
function update_status(status, text)
%  Description:
%    Update the status bar in the left panel to indicate the current status
%    of the code.
% -------------------------------------------------------------------------
%  -Busy
%    update_status('b', 'some text');
%  -Interactive
%    update_status('i', 'some text');
%  -Standby
%    update_status('s', 'some text');
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, ~] = gui_data;

colorBusy = [0.8 0 0];
colorInteractive = [0.8 0.6 0];
colorStandby = [0 0.6 0.2];
switch status
    case 'b'
        color = colorBusy;
    case 'i'
        color = colorInteractive;
    case 's'
        color = colorStandby;
end
set(uiHandles.left.status.icon, 'ForegroundColor', color);
set(uiHandles.left.status.text, 'String', text);
drawnow;
end

%% Suppress button status while busying
%  suppress_btn_stat('some text');
function suppress_btn_stat(text)
%  Description:
%    Suppress the UI elements while busying to avoid misinput by the user.
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, uiFlags] = gui_data;

uiFlags.status.new = arrayfun(@(x) strcmp(get(x, 'Enable'), 'on'), uiHandles.cat);
arrayfun(@(x) set(x, 'Enable', 'off'), uiHandles.cat);

update_status('b', text);
gui_data([], [], [], [], [], uiFlags);
end

%% Release button suppression
%  release_btn_stat('i'/'s', 'some text', (on)[1 2 3], (off)[4 5 6]);
function release_btn_stat(status, text, varargin)
%  Description:
%    Release the suppressed button and change the on/off of specific
%    buttons. The index of the buttons are from 'cat_btn_handles'.
% -------------------------------------------------------------------------
%  -Interactive
%    release_btn_stat('i', 'some text', [1 2 3], [4 5 6]);
%  -Standby                              (on)     (off)
%    release_btn_stat('s', 'some text', [1 2 3], [4 5 6]);
%  -Remain                               (on)     (off)
%    release_btn_stat('s', 'some text');
%  -Reverse
%    release_btn_stat('s', 'some text', 'r');
%  -Elements
%     1. uiHandles.left.dir(1,1).textbox;
%     2. uiHandles.left.dir(1,1).button;
%     3. uiHandles.left.dir(1,2).textbox;
%     4. uiHandles.left.dir(1,2).button;
%     5. uiHandles.left.dir(1,3).textbox;
%     6. uiHandles.left.dir(1,3).button;
%     7. uiHandles.left.set(1,1).textbox;
%     8. uiHandles.left.set(1,2).textbox;
%     9. uiHandles.left.set(1,3).textbox;
%    10. uiHandles.left.main(1,1).button;
%    11. uiHandles.left.main(1,2).button;
%    12. uiHandles.left.main(1,3).back;
%    13. uiHandles.left.main(1,3).next;
%    14. uiHandles.mid.set(1,1).textbox;
%    15. uiHandles.mid.set(1,2).textbox;
%    16. uiHandles.mid.set(1,3).textbox;
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, uiFlags] = gui_data;

if nargin == 4
    if ~isempty(varargin{1})
        uiFlags.status.new(varargin{1},1) = true;
    end
    if ~isempty(varargin{2})
        uiFlags.status.new(varargin{2},1) = false;
    end
    if ~isfield(uiFlags.status, 'old')
        uiFlags.status.old = uiFlags.status.new;
    elseif ~isequal(uiFlags.status.old(:, end), uiFlags.status.new)
        uiFlags.status.old = [uiFlags.status.old uiFlags.status.new];
    end
elseif nargin == 3
    if isfield(uiFlags.status, 'old')
        uiFlags.status.old = uiFlags.status.old(:,1:end-1);
        uiFlags.status.new = uiFlags.status.old(:,end);
    end
end
arrayfun(@(x) set(x, 'Enable', 'on'), uiHandles.cat(uiFlags.status.new,1));

update_status(status, text);
gui_data([], [], [], [], [], uiFlags);
end

%% Update button string and callback
%  update_btn_stat(3, 'button', @callback_fnc);
function update_btn_stat(btnIndex, str, callback, varargin)
%  Description:
%    Update the string or callback function of the selected button. The
%    index of the buttons are from 'cat_btn_handles'.
% -------------------------------------------------------------------------
%  -String:
%    update_btn_stat(3, 'button', []);
%  -Callback:
%    update_btn_stat(3, '', @callback_fnc);
%  -Elements
%     1. uiHandles.left.dir(1,1).textbox;
%     2. uiHandles.left.dir(1,1).button;
%     3. uiHandles.left.dir(1,2).textbox;
%     4. uiHandles.left.dir(1,2).button;
%     5. uiHandles.left.dir(1,3).textbox;
%     6. uiHandles.left.dir(1,3).button;
%     7. uiHandles.left.set(1,1).textbox;
%     8. uiHandles.left.set(1,2).textbox;
%     9. uiHandles.left.set(1,3).textbox;
%    10. uiHandles.left.main(1,1).button;
%    11. uiHandles.left.main(1,2).button;
%    12. uiHandles.left.main(1,3).back;
%    13. uiHandles.left.main(1,3).next;
%    14. uiHandles.mid.set(1,1).textbox;
%    15. uiHandles.mid.set(1,2).textbox;
%    16. uiHandles.mid.set(1,3).textbox;
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, ~] = gui_data;
if ~isempty(str)
    set(uiHandles.cat(btnIndex,1), 'String', str);
end
if ~isempty(callback)
    set(uiHandles.cat(btnIndex,1), 'Callback', callback);
end
if nargin == 4
    if strcmp(varargin{1}, 'on')
        set(uiHandles.cat(btnIndex,1), 'Visible', 'on');
    else
        set(uiHandles.cat(btnIndex,1), 'Visible', 'off');
    end
end
end

%% Update guide text
%  update_guide({'\bfSomething...'; '\lb'; 'Something...'}, ('k'));
function update_guide(strArray, varargin)
%  Description:
%    Update the image and text in user guide. The gap between the lines can
%    be set here.
% -------------------------------------------------------------------------
%  -Example:
%    update_guide({ ...
%        '\bfSomething...'; ... <-- '\bf' will change the line into bold
%        '\lb'; ...             <-- '\lb' will set the line break
%        'Something...'}, ...
%        'k');                  <-- (optional) use the guide with keyboard
% -------------------------------------------------------------------------
[uiHandles, ~, ~, uiImage, ~, ~] = gui_data;

gap = [16 7];
deduct = 3;
length = 58;

position = get(uiHandles.right.guide.text(1,1), 'Position');
fontSize = get(uiHandles.right.guide.text(1,1), 'FontSize');
fontColor = get(uiHandles.right.guide.text(1,1), 'Color');

delete(uiHandles.right.guide.text);
cla(uiHandles.right.panel);
axes(uiHandles.right.panel);
if nargin == 1
    imshow(uiImage.guide.original);
else
    imshow(uiImage.guide.keyboard);
end
idx = 1;
for i = 1:size(strArray, 1)
    head = true;
    bold = false;
    list = false;
    indent = false;
    if strcmp(strArray{i,1}(1,1:3), '\bf')
        bold = true;
        strArray{i,1} = strArray{i,1}(1,4:end);
    elseif strcmp(strArray{i,1}(1,1:3), '\lt')
        list = true;
        strArray{i,1} = strArray{i,1}(1,4:end);
    elseif strcmp(strArray{i,1}(1,1:3), '\id')
        indent = true;
        strArray{i,1} = strArray{i,1}(1,4:end);
        if head
            position(1,2) = position(1,2)-gap(1,2);
        end
    end
    while ~isempty(strArray{i,1})
        tempLength = length+1;
        if list && head
            strArray{i,1} = ['  ' strArray{i,1}];
        elseif list
            strArray{i,1} = ['      ' strArray{i,1}];
        elseif indent
            strArray{i,1} = ['  ' strArray{i,1}];
        elseif bold
            tempLength = tempLength-deduct;
        end
        idxSpace = [find(isspace(strArray{i,1})) size(strArray{i,1},2)];
        idxBreak = idxSpace(1,logical([diff(idxSpace>tempLength) 0]));
        if ~isempty(idxBreak)
            str = strArray{i,1}(1,1:idxBreak-1);
            strArray{i,1} = strArray{i,1}(1,idxBreak+1:end);
        else
            str = strArray{i,1};
            strArray{i,1} = '';
        end
        if bold
            str = ['\bf' str]; %#ok<AGROW>
        end
        uiHandles.right.guide.text(idx,1) = text( ...
            position(1,1), position(1,2), ...
            str, ...
            'Color', fontColor, ...
            'FontSize', fontSize, ...
            'Interpreter', 'tex');
        idx = idx+1;
        head = false;
        position(1,2) = position(1,2)+gap(1,1);
    end
    position(1,2) = position(1,2)+gap(1,2);
end

gui_data(uiHandles, [], [], [], [], []);
end

%% Toggle slider
%  toggle_slider('on'/'off');
function toggle_slider(status)
%  Description:
%    Turn the slider group on/off. The default value is set to 885.5 if
%    it's in the m/z boundary. Otherwise, it is set to the mean of the
%    upper and lower boundary.
% -------------------------------------------------------------------------
[uiHandles, uiSize, uiData, ~, uiSetting, ~] = gui_data;

if get(uiHandles.mid.scroll.slider, 'Value') <= 1
    mzTarget = 885.5;
else
    mzTarget = get(uiHandles.mid.scroll.slider, 'Value');
end

if strcmp(status, 'on')
    if mzTarget >= uiSetting.mzUpper || mzTarget <= uiSetting.mzLower
        mzTarget = round(mean([uiSetting.mzUpper uiSetting.mzLower]), 1);
    end
    
    set(uiHandles.mid.scroll.slider, 'Enable', 'on', ...
        'Max', uiSetting.mzUpper, ...
        'Min', uiSetting.mzLower, ...
        'SliderStep', (uiSetting.tolerance/(uiSetting.mzUpper-uiSetting.mzLower))*[1 10], ...
        'Value', mzTarget, ...
        'Callback', @callback_slider);
    set(uiHandles.mid.scroll.textbox, 'Enable', 'on', ...
        'String', mzTarget, ...
        'Callback', @callback_slider_textbox);
    set(uiHandles.window, 'WindowScrollWheelFcn', @callback_scroll);
    
    % Show the colorbar of the spectra
    cBar = uiHandles.mid.scroll.colorbar.CData;
    data = squeeze(sum(sum(uiData.spectra, 1), 2));
    resizeData = imresize(flipud(data), [size(cBar, 1), size(cBar, 2)]);
    normalizeData = round((resizeData-min(min(resizeData,[],1),[],2))/(max(max(resizeData,[],1),[],2)-min(min(resizeData,[],1),[],2))*255);
    cMap = colormap(hot);
    uiHandles.mid.scroll.colorbar.CData = ind2rgb(normalizeData, cMap);
    drawnow;
else
    set(uiHandles.mid.scroll.slider, 'Enable', 'off');
    set(uiHandles.mid.scroll.textbox, 'Enable', 'off');
    set(uiHandles.window, 'WindowScrollWheelFcn', []);
    
    cla(uiHandles.mid.scroll.coloraxes);
    axes(uiHandles.mid.scroll.coloraxes);
    uiHandles.mid.scroll.colorbar = imshow(ind2rgb(ones(uiSize.mid.scroll.colorbar(1,2), uiSize.mid.scroll.colorbar(1,1)), [0.8 0.8 0.8]));
    gui_data(uiHandles, [], [], [], [], []);
end
end


%% Image related
%% Resize image
% resizedImg = resize_image(image, ('map'/'fit'));
function resizedImg = resize_image(image, varargin)
%  Description:
%    Resize and crop the image to the size of the figure axes.
% -------------------------------------------------------------------------
[~, uiSize, ~, ~, ~, ~] = gui_data;

if nargin == 2
    if strcmp(varargin{1}, 'map')
        cMap = colormap(hot);
        image = round(interp1(linspace(min(image(:)), max(image(:)),size(cMap, 1)),1:size(cMap, 1),image));
        image = reshape(cMap(image,:), [size(image) 3]);
        resizedImg = imresize(image, uiSize.resolution/size(image, uiSize.dynamic.direction), 'nearest');
    elseif strcmp(varargin{1}, 'fit')
        resizedImg = imresize(image, uiSize.dynamic.spectra.resized, 'nearest');
    end
else
    resizedImg = imresize(image, uiSize.resolution/size(image, uiSize.dynamic.direction), 'nearest');
end
end

%% Update the images in main figure axes
%  update_image(imgBelow, imgAbove, (0.5));
function update_image(imgBelow, imgAbove, varargin)
%  Description:
%    Update the image in main figure axes. If the image axes is not
%    initialized, initialize it.
% -------------------------------------------------------------------------
%  -Above
%    update_image([], imgAbove);
%  -Below
%    update_image(imgBelow, []);
%  -Alpha
%    update_image(imgBelow, imgAbove, 0.5);
% -------------------------------------------------------------------------
[uiHandles, ~, ~, ~, ~, uiFlags] = gui_data;

if nargin == 3
    set(uiHandles.mid.image.above, 'AlphaData', varargin{1});
end
if uiFlags.image
    if ~isempty(imgBelow)
        uiHandles.mid.image.below.CData = imgBelow;
    end
    if ~isempty(imgAbove)
        uiHandles.mid.image.above.CData = imgAbove;
    end
else
    if ~isempty(imgBelow)
        image = imgBelow;
    elseif ~isempty(imgAbove)
        image = imgAbove;
    end
    cla(uiHandles.mid.axes);
    axes(uiHandles.mid.axes);
    uiHandles.mid.image.below = imshow(image);
    hold(uiHandles.mid.axes, 'on');
    uiHandles.mid.image.above = imshow(image);
    hold(uiHandles.mid.axes, 'off');
    set(uiHandles.mid.image.above, 'AlphaData', 0);
    uiFlags.image = true;
end

gui_data(uiHandles, [], [], [], [], uiFlags);
drawnow;
end

%% Update the spectra image
%  update_spectra(('bw'));
function update_spectra(varargin)
%  Description:
%    Update the spectra image shown on the figure axes. Use 'bw' to change
%    the output figure to b/w.
% -------------------------------------------------------------------------
%  -Normal
%    update_spectra;
%  -B/W
%    update_spectra('bw');
% -------------------------------------------------------------------------
[uiHandles, uiSize, uiData, ~, ~, ~] = gui_data;

mzTarget = get(uiHandles.mid.scroll.slider, 'Value');
[~, idx] = min(abs(uiData.mzInterval-mzTarget));
rawImg = squeeze(uiData.spectra(:,:,idx));
resizedImg = resize_image(rawImg, 'map');
uiSize.dynamic.spectra.resized = [size(resizedImg, 1) size(resizedImg, 2)];
if nargin == 1
    grayImg = imadjust(rgb2gray(resizedImg));
    catImg = cat(3, grayImg, grayImg, grayImg);
    update_image(catImg, []);
else
    update_image(resizedImg, [], 0);
end

gui_data([], uiSize, [], [], [], []);
end

%% Apply transformation to the image
function apply_transform
%  Description:
%    Apply the transformation matrix to the stained image and update the
%    figure axes.
% -------------------------------------------------------------------------
[~, uiSize, ~, uiImage, uiSetting, ~] = gui_data;

matrixCenter = [1, 0, 0; ...
    0, 1, 0; ...
    -uiSize.dynamic.spectra.resized(1,2)/2, -uiSize.dynamic.spectra.resized(1,1)/2, 1];
matrixRotate = [cosd(uiSetting.transform.value.rotate), -sind(uiSetting.transform.value.rotate), 0; ...
    sind(uiSetting.transform.value.rotate), cosd(uiSetting.transform.value.rotate), 0; ...
    0, 0, 1];
matrixCenterInv = [1, 0, 0; ...
    0, 1, 0; ...
    uiSize.dynamic.spectra.resized(1,2)/2, uiSize.dynamic.spectra.resized(1,1)/2, 1];
matrixScale = [uiSetting.transform.value.scale(1, 1), 0, 0; ...
    0, uiSetting.transform.value.scale(1, 2), 0; ...
    0, 0, 1];
matrixTranslate = [1, 0, 0; ...
    0, 1, 0; ...
    uiSetting.transform.value.translate, 1];
uiSetting.transform.matrix.final = uiSetting.transform.matrix.original* ...
    matrixCenter*matrixScale*matrixRotate*matrixCenterInv*matrixTranslate;

translation = affine2d(uiSetting.transform.matrix.final);
transImg = imwarp(uiImage.marked.resized, translation, 'nearest', ...
    'FillValues', 255, 'OutputView', imref2d(uiSize.dynamic.spectra.resized));

update_image([], transImg, 0.5);

gui_data([], [], [], [], uiSetting, []);
end

%% Transform images
%  transImg = transform_image(image);
function transImg = transform_image(image)
%  Description:
%    Transform the images base on the transformation matrix. The image with
%    original resolution are used here.
% -------------------------------------------------------------------------
[~, uiSize, ~, ~, uiSetting, ~] = gui_data;

scale = size(image, uiSize.dynamic.direction) ...
    /uiSize.dynamic.spectra.resized(1, uiSize.dynamic.direction);
matrixScale = [scale, 0, 0; ...
    0, scale, 0; ...
    0, 0, 1];
matrixScaleInv = [1/scale, 0, 0; ...
    0, 1/scale, 0; ...
    0, 0, 1];

translation = affine2d(matrixScaleInv*uiSetting.transform.matrix.final*matrixScale);
transImg = imwarp(image, translation, 'nearest', ...
    'FillValues', 255, 'OutputView', imref2d(round(scale*uiSize.dynamic.spectra.resized)));
end

%% Generate mask
%  [mask, boundary] = generate_mask(image, [15 22 15], 50);
function [mask, boundary] = generate_mask(image, color, tolerance)
%  Description:
%    Extract the mask and generate the boundary from the color.
% -------------------------------------------------------------------------
range = color_range(color, tolerance);

boundaryR = (image(:,:,1)<=range(1,1)).*(image(:,:,1)>=range(2,1));
boundaryG = (image(:,:,2)<=range(1,2)).*(image(:,:,2)>=range(2,2));
boundaryB = (image(:,:,3)<=range(1,3)).*(image(:,:,3)>=range(2,3));
boundary = logical(boundaryR.*boundaryG.*boundaryB);
mask = imfill(boundary, 'holes');
end

%% Color range
%  range = color_range([15 22 15], 50);
function range = color_range(targetColor, tolerance)
%  Description:
%    Generate the range of the color with selected tolerance.
% -------------------------------------------------------------------------
upperBound = [255 255 255];
lowerBound = [0 0 0];
upperTarget = targetColor*255+tolerance/2;
lowerTarget = targetColor*255-tolerance/2;
upperSubplus = subplus(upperTarget-upperBound);
lowerSubplus = subplus(lowerBound-lowerTarget);
upperTarget(upperTarget>255) = 255;
lowerTarget(lowerTarget<0) = 0;
upperTarget = upperTarget+lowerSubplus;
lowerTarget = lowerTarget-upperSubplus;

range = [upperTarget; lowerTarget];
end





%% Debug functions
%  ========================================================================
%  This function will generate a small button in the lower left corner for
%  debugging. Pressing the button will cause the UI to return appdata.

function debug(status)
if strcmp(status, 'on')
    uicontrol(gcf, ...
        'Units', 'pixels', ...
        'Position', [5 5 15 15], ...
        'Style', 'pushbutton', ...
        'String', '', ...
        'Callback', @callback_debug);
elseif strcmp(status, 'off')
end
end

function callback_debug(~, ~)
[uiHandles, uiSize, uiData, uiImage, uiSetting, uiFlags] = gui_data;

assignin('base','uiHandles',uiHandles);
assignin('base','uiSize',uiSize);
assignin('base','uiData',uiData)
assignin('base','uiImage',uiImage);
assignin('base','uiSetting',uiSetting);
assignin('base','uiFlags',uiFlags)
end
