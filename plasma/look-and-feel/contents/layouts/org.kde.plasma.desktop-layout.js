var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
                {
                    "config": {
                        "/": {
                            "PreloadWeight": "62"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.digitalclock",
                    "title": "Digital Clock"
                }
            ],
            "config": {
                "/": {
                    "ItemGeometriesHorizontal": "Applet-26:2176,96,288,112,0;",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "720",
                    "DialogWidth": "960"
                },
                "/Configuration": {
                    "PreloadWeight": "42"
                },
                "/General": {
                    "ToolBoxButtonState": "topcenter",
                    "ToolBoxButtonX": "1050"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "file:///home/alex/Pictures/astronaut-jellyfish-space.jpg"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
        {
            "alignment": "left",
            "applets": [
                {
                    "config": {
                        "/": {
                            "immutability": "1"
                        },
                        "/Configuration": {
                            "PreloadWeight": "100"
                        },
                        "/Configuration/ConfigDialog": {
                            "DialogHeight": "840",
                            "DialogWidth": "1120"
                        },
                        "/Configuration/General": {
                            "alphaSort": "true",
                            "favoritesPortedToKAstats": "true",
                            "menuItems": "bookmark:t,application:t,leave:t,computer:t,used:t,oftenUsed:f",
                            "switchTabsOnHover": "false",
                            "useExtraRunners": "false"
                        },
                        "/Configuration/Shortcuts": {
                            "global": "Alt+F1"
                        },
                        "/Shortcuts": {
                            "global": "Alt+F1"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff"
                },
                {
                    "config": {
                        "/": {
                            "immutability": "1"
                        },
                        "/Configuration": {
                            "PreloadWeight": "42"
                        },
                        "/Configuration/ConfigDialog": {
                            "DialogHeight": "720",
                            "DialogWidth": "960"
                        },
                        "/Configuration/General": {
                            "wrapPage": "true"
                        }
                    },
                    "plugin": "org.kde.plasma.pager"
                },
                {
                    "config": {
                        "/": {
                            "immutability": "1"
                        },
                        "/Configuration": {
                            "PreloadWeight": "42"
                        },
                        "/Configuration/ConfigDialog": {
                            "DialogHeight": "720",
                            "DialogWidth": "960"
                        }
                    },
                    "plugin": "org.kde.plasma.taskmanager"
                },
                {
                    "config": {
                        "/": {
                            "immutability": "1"
                        },
                        "/Configuration": {
                            "PreloadWeight": "57"
                        }
                    },
                    "plugin": "org.kde.plasma.systemtray"
                },
                {
                    "config": {
                        "/": {
                            "immutability": "1"
                        },
                        "/Configuration": {
                            "PreloadWeight": "42"
                        }
                    },
                    "plugin": "org.kde.plasma.pager"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "97",
                    "DialogWidth": "2560"
                },
                "/Configuration": {
                    "PreloadWeight": "42"
                }
            },
            "height": 1.2857142857142858,
            "hiding": "normal",
            "location": "bottom",
            "maximumLength": 91.42857142857143,
            "minimumLength": 91.42857142857143,
            "offset": 0
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
