const defaultTheme = {
    primary: "#0b4f6c",
    secondary: "#9ee493",
    background: "#daf7dc",
    text: "#000000"
}

const darkTheme = {
    primary: "#ffffff",
    secondary: "#9ee493",
    background: "#000000",
    text: "#ffffff"
}

//TODO this could happen on document load and not every turbolink reload?

//Setup default theme once
const themePickers = document.getElementsByClassName("theme-picker")
setPickersToTheme(themePickers, defaultTheme)

document.addEventListener("turbolinks:load", function() {
    const themePickers = document.getElementsByClassName("theme-picker")
    const themeingToggle = document.getElementById("toggle-color-theme")
    setupThemeBoxDisplay(themeingToggle)
    setupThemePickerEventListeners(themePickers)
    setupPresetThemePickers(themePickers)
})

function setupThemeBoxDisplay(themeingToggle) {
    const themeBox = document.getElementById("css-themeing")
    themeBox.style.display = "none";
    themeingToggle.addEventListener("click", function(e) {
        e.preventDefault();
        const isHidden = themeBox.style.display === 'none'
        if (isHidden) {
            themeBox.style.display = "block";
        } else {
            themeBox.style.display = "none";
        }
    })
}

function setupThemePickerEventListeners(themePickers) {
    Array.from(themePickers).forEach(function(colorPickerElement) {
        colorPickerElement.addEventListener("change", function(e) {
            const name = e.target.name;
            const value = e.target.value;
            updateDocumentTheme(name, value)
        })
    });
}

function setPickersToTheme(themePickers, theme) {
    Array.from(themePickers).forEach(function(colorPickerElement) {
        const name = colorPickerElement.name;
        const value = theme[name];
        colorPickerElement.value = value;
        updateDocumentTheme(name, value)
    })
}

function updateDocumentTheme(name, value) {
    const cssVariableName = "--" + name + "-color";
    document.documentElement.style.setProperty(cssVariableName, value);
}

function setupPresetThemePickers(themePickers) {
    const defaultPreset = document.getElementById("default-color-theme");
    defaultPreset.addEventListener("click", function(e) {
        e.preventDefault();
        setPickersToTheme(themePickers, defaultTheme)
    })

    const darkPreset = document.getElementById("dark-color-theme");
    darkPreset.addEventListener("click", function(e) {
        e.preventDefault();
        setPickersToTheme(themePickers, darkTheme)
    })
}