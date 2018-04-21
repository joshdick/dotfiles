/* global _, Event, Key, Modal, Phoenix, Screen, Window */

// [Josh Dick's](https://github.com/joshdick/dotfiles) [Phoenix](https://github.com/kasper/phoenix) configuration
// Based on [Jaredk3nt/phoenix-padding/](https://github.com/Jaredk3nt/phoenix-padding/)

// Usage:
// Repeating any of the following commands multiple times will move the window to the next screen with the same orientation:
//     ctrl + cmd + up -> Maximize the window.
//     ctrl + cmd + left, ctrl + cmd + right -> Make the window occupy 1/2 of the screen vertically on the corresponding side.
//     ctrl + cmd + [1, 3, 7, 9] -> Make the window occupy 1/4 of the screen in the corresponding corner.
// Add 'alt' to any shortcut to move the window without padding.

const SHOW_NOTIFICATIONS = true;
const HALF_CORRECTION = 6; // Fix padding issues for half screen windows

const paddingTop = 35;
const paddingLeft = 15;
const paddingRight = 30;
const paddingBottom = 25;
const paddingCenter = 10;
const paddingMiddle = 20;

const FULL_SCREEN = Symbol('FULL_SCREEN');
const LEFT_HALF = Symbol('LEFT_HALF');
const RIGHT_HALF = Symbol('RIGHT_HALF');
const TOP_RIGHT = Symbol('TOP_RIGHT');
const BOTTOM_RIGHT = Symbol('BOTTOM_RIGHT');
const TOP_LEFT = Symbol('TOP_LEFT');
const BOTTOM_LEFT = Symbol('BOTTOM_LEFT');

const PADDED = Symbol('PADDED');
const UNPADDED = Symbol('UNPADDED');

const PADDED_MODIFIERS = ['ctrl', 'cmd'];
const UNPADDED_MODIFIERS = ['ctrl', 'alt', 'cmd'];

const bindings = [
	['keypad7', 'top left', TOP_LEFT],
	['left', 'left', LEFT_HALF],
	['keypad1', 'bottom left', BOTTOM_LEFT],
	['keypad3', 'bottom right', BOTTOM_RIGHT],
	['right', 'right', RIGHT_HALF],
	['keypad9', 'top right', TOP_RIGHT],
	['up', 'fullscreen', FULL_SCREEN],
];

const getUnpaddedFrames = (screenFrame) => {

	const halfWidthUnpadded = screenFrame.width / 2;
	const halfHeightUnpadded = screenFrame.height / 2;

	return {

		[FULL_SCREEN]: {
			x: screenFrame.x + 0,
			y: screenFrame.y + 0,
			width: screenFrame.width,
			height: screenFrame.height,
		},
		[LEFT_HALF]: {
			x: screenFrame.x + 0,
			y: screenFrame.y + 0,
			width: halfWidthUnpadded,
			height: screenFrame.height,
		},
		[RIGHT_HALF]: {
			x: screenFrame.x + halfWidthUnpadded,
			y: screenFrame.y + 0,
			width: halfWidthUnpadded,
			height: screenFrame.height,
		},
		[TOP_RIGHT]: {
			x: screenFrame.x + halfWidthUnpadded,
			y: screenFrame.y + 0,
			width: halfWidthUnpadded,
			height: halfHeightUnpadded,
		},
		[BOTTOM_RIGHT]: {
			x: screenFrame.x + halfWidthUnpadded,
			y: screenFrame.y + halfHeightUnpadded,
			width: halfWidthUnpadded,
			height: halfHeightUnpadded,
		},
		[TOP_LEFT]: {
			x: screenFrame.x + 0,
			y: screenFrame.y + 0,
			width: halfWidthUnpadded,
			height: halfHeightUnpadded,
		},
		[BOTTOM_LEFT]: {
			x: screenFrame.x + 0,
			y: screenFrame.y + halfHeightUnpadded,
			width: halfWidthUnpadded,
			height: halfHeightUnpadded,
		},
	};

};

const getPaddedFrames = (screenFrame) => {

	const halfWidthPadded = ((screenFrame.width - paddingLeft) - paddingRight) / 2;
	const halfHeightPadded = (((screenFrame.height - paddingTop) - paddingBottom) / 2) + HALF_CORRECTION;

	return {

		[FULL_SCREEN]: {
			x: screenFrame.x + paddingLeft,
			y: screenFrame.y + paddingTop,
			width: screenFrame.width - paddingRight,
			height: screenFrame.height - paddingBottom,
		},
		[LEFT_HALF]: {
			x: screenFrame.x + paddingLeft,
			y: screenFrame.y + paddingTop,
			width: halfWidthPadded - paddingCenter,
			height: screenFrame.height - paddingBottom,
		},
		[RIGHT_HALF]: {
			x: screenFrame.x + (halfWidthPadded + paddingLeft) + paddingCenter,
			y: screenFrame.y + paddingTop,
			width: halfWidthPadded,
			height: screenFrame.height - paddingBottom,
		},
		[TOP_RIGHT]: {
			x: screenFrame.x + (halfWidthPadded + paddingLeft) + paddingCenter,
			y: screenFrame.y + paddingTop,
			width: halfWidthPadded,
			height: halfHeightPadded,
		},
		[BOTTOM_RIGHT]: {
			x: screenFrame.x + (halfWidthPadded + paddingLeft) + paddingCenter,
			y: screenFrame.y + (halfHeightPadded + paddingTop) + paddingMiddle,
			width: halfWidthPadded,
			height: halfHeightPadded,
		},
		[TOP_LEFT]: {
			x: screenFrame.x + paddingLeft,
			y: screenFrame.y + paddingTop,
			width: halfWidthPadded - paddingCenter,
			height: halfHeightPadded,
		},
		[BOTTOM_LEFT]: {
			x: screenFrame.x + paddingLeft,
			y: screenFrame.y + (halfHeightPadded + paddingTop) + paddingMiddle,
			width: halfWidthPadded - paddingCenter,
			height: halfHeightPadded,
		},
	};

};

const showNotification = (screenFrame, window, message) => {
	Modal.build({
		origin: (modal) => {
			return {
				x: screenFrame.x + (screenFrame.width / 2) - (modal.width / 2),
				y: screenFrame.y + (screenFrame.height / 2) - (modal.height / 2),
			};
		},
		weight: 20,
		duration: 1,
		appearance: 'dark',
		icon: window.app().icon(),
		text: `Moved ${window.app().name()} to ${message}`,
	}).show();
};

const keyHandlerIDs = [];
let screenReconfigurationEvent;
let lastRequestedFrame;

const initialize = () => {

	// Unbind any previously-bound screen reconfiguration event
	if (screenReconfigurationEvent) {
		screenReconfigurationEvent.disable();
	}

	// Unbind any previously-bound key handlers
	keyHandlerIDs.forEach((keyHandlerID) => {
		Key.off(keyHandlerID);
	});

	// Initialize caches
	const frameCache = {};
	const screens = {};
	const screenIDs = [];

	let visibleXOffset = 0;
	const visibleYOffset = 0;
	let fullXOffset = 0;
	const fullYOffset = 0;

	// Populate thes screen map, the screen ID list, and the frame cache for each screen
	Screen.all().forEach((screen) => {
		const screenID = screen.identifier();
		screens[screenID] = screen;
		screenIDs.push(screenID);

		const visibleFrame = screen.flippedVisibleFrame();
		const fullFrame = screen.flippedFrame();

		const adjustedVisible = Object.assign({}, visibleFrame, { x: visibleXOffset, y: visibleYOffset });
		const adjustedFull = Object.assign({}, visibleFrame, { x: fullXOffset, y: fullYOffset });

		frameCache[screenID] = {
			[PADDED]: getPaddedFrames(adjustedVisible),
			[UNPADDED]: getUnpaddedFrames(adjustedFull),
		};

		visibleXOffset += visibleFrame.width;
		fullXOffset += fullFrame.width;
		//visibleYOffset += visibleFrame.height;
		//fullYOffset = fullFrame.height;

	});

	const getHandler = (frameType, notificationText, position) => {
		return () => {

			const focusedWindow = Window.focused();
			const currentScreen = focusedWindow.screen();

			let destinationScreen;
			let destinationFrame;

			const requestedFrame = frameCache[currentScreen.identifier()][frameType][position];

			// If the window is already in the requested postion, put it in the same position on the next screen
			if (_.isEqual(requestedFrame, lastRequestedFrame)) {
				const currentScreenIndex = screenIDs.indexOf(currentScreen.identifier());
				const nextScreenIndex = currentScreenIndex === screenIDs.length - 1 ? 0 : currentScreenIndex + 1;
				const destinationScreenID = screenIDs[nextScreenIndex];
				destinationFrame = frameCache[destinationScreenID][frameType][position];
				destinationScreen = screens[destinationScreenID];
			} else {
				destinationFrame = requestedFrame;
				destinationScreen = currentScreen;
			}

			if (SHOW_NOTIFICATIONS) showNotification(destinationScreen.frame(), focusedWindow, notificationText);
			focusedWindow.setFrame(destinationFrame);
			lastRequestedFrame = destinationFrame;

		};
	};

	bindings.forEach((binding) => {
		const [key, notificationText, position] = binding;
		keyHandlerIDs.push(
			Key.on(key, PADDED_MODIFIERS, getHandler(PADDED, notificationText, position))
		);
		keyHandlerIDs.push(
			Key.on(key, UNPADDED_MODIFIERS, getHandler(UNPADDED, notificationText, position))
		);
	});

	screenReconfigurationEvent = new Event('screensDidChange', initialize);

};

Phoenix.set({
	openAtLogin: true,
});

initialize();
