module.exports = {
  config: {
    // default font size in pixels for all tabs
    fontSize: 13,

    // font family with optional fallbacks
    fontFamily: 'PragmataPro Mono',

    // terminal cursor background color (hex)
    cursorColor: '#c7c7c7',

    // color of the text
    foregroundColor: '#abb2bf',

    // terminal background color
    backgroundColor: '#282c34', // 'rgba(40, 44, 52, .9)',

    // border color (window, tabs)
    borderColor: '#5b5f67',

    // custom css to embed in the main window
    css: `
      .hyper_main {
        border: 0;
      }
    `,

    // custom padding (css format, i.e.: `top right bottom left`)
    termCSS: `
      span {
        -webkit-font-smoothing: subpixel-antialiased;
      }

      /* 1.25 dpr */
      @media
      (-webkit-min-device-pixel-ratio: 1.25),
      (min-resolution: 120dpi) {
        span {
          -webkit-font-smoothing: antialiased;
        }
      }

      /* 1.3 dpr */
      @media
      (-webkit-min-device-pixel-ratio: 1.3),
      (min-resolution: 124.8dpi) {
        span {
          -webkit-font-smoothing: antialiased;
        }
      }

      /* 1.5 dpr */
      @media
      (-webkit-min-device-pixel-ratio: 1.5),
      (min-resolution: 144dpi) {
        span {
          -webkit-font-smoothing: antialiased;
        }
      }
    `,

    // custom padding
    padding: '5px',

    // some color overrides. see http://bit.ly/29k1iU2 for
    // the full list
    colors: {
        'black':        '#282C34',
        'red':          '#e06c75',
        'green':        '#98c379',
        'yellow':       '#e5c07b',
        'blue':         '#61afef',
        'magenta':      '#c678dd',
        'cyan':         '#56b6c2',
        'white':        '#abb2bf',
        'lightBlack':   '#808080',
        'lightRed':     '#be5046',
        'lightGreen':   '#98c379',
        'lightYellow':  '#d19a66',
        'lightBlue':    '#61afef',
        'lightMagenta': '#c678dd',
        'lightCyan':    '#56b6c2',
        'lightWhite':   '#ffffff'
        //'colorCubes':
        //'grayscale':
    }
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hypersolar`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []

};
