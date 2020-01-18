// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')
const path = require('path')

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

const windowHeight = 800;
const windowWeight = windowHeight;

function createWindow () {
  let hour = (new Date()).getHours();

  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: windowHeight,
    height: windowWeight,
    // Adjust background colour so that it looks better when resized
    backgroundColor: hour > 17 || hour < 7 ? '#282828' : '#FFFFFF',
    icon: path.join(__dirname, 'assets/icons/icon'),
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    },
    show: false,
    autoHideMenuBar: true
  })
  
  // Prevent white splash
  mainWindow.once('ready-to-show', () => {
    mainWindow.show()
  })

  // and load the index.html of the app.
  mainWindow.loadFile('index.html')

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') app.quit()
})

/**
 * counter of broswer window
 */
let counter = 0
app.on('browser-window-created', (_, w) => {
  if (counter++ > 0) {
    // same size with main window
    let sized = mainWindow.getSize()
    w.setSize(sized[0], sized[1])

    // let the new window cover main window
    let pos = mainWindow.getPosition()
    w.setPosition(pos[0], pos[1])
  }
})

app.on('activate', function () {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) createWindow()
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
