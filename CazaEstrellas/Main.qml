import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ApplicationWindow {
    id: ventana
     width: 390
     height: 740
     minimumWidth: 320
     minimumHeight: 550
     visible: true
     title: "Órbita Fugaz"
     color: "#101827"

     property int pantalla: 0
     property string nombreJugador: ""
     property string aliasJugador: ""
     property int edadJugador: 0
     property string dificultad: "Normal"

     property int puntos: 0
     property int tiempo: 30
     property int combo: 0
     property int mejorCombo: 0
     property int estrellas: 0
     property int meteoritos: 0

     property bool jugando: false
     property bool pausado: false
     property bool partidaTerminada: false
     property bool sonidoActivo: true

     property int tipoObjetivo: 0
     property int tamañoObjetivo: 65
     property real posicionX: 0
     property real posicionY: 0
     property string avisoEtapa: ""

     readonly property int etapa: tiempo > 20 ? 1 : tiempo > 10 ? 2 : 3
     readonly property int intervaloObjetivos: {
         if (dificultad === "Fácil")
             return etapa === 1 ? 1800 : etapa === 2 ? 1300 : 900

         if (dificultad === "Normal")
             return etapa === 1 ? 1400 : etapa === 2 ? 950 : 600

         return etapa === 1 ? 1050 : etapa === 2 ? 700 : 400
     }

     function cambiarObjetivo() {
         tipoObjetivo = Math.random() < 0.25 ? 1 : 0

         posicionX = Math.random() *
                     Math.max(0, zonaJuego.width - tamañoObjetivo)

         posicionY = Math.random() *
                     Math.max(0, zonaJuego.height - tamañoObjetivo)
     }

     function iniciarJuego() {
         puntos = 0
         tiempo = 30
         combo = 0
         mejorCombo = 0
         estrellas = 0
         meteoritos = 0
         pausado = false
         partidaTerminada = false
         avisoEtapa = ""

         if (dificultad === "Fácil")
             tamañoObjetivo = 85
         else if (dificultad === "Normal")
             tamañoObjetivo = 65
         else
             tamañoObjetivo = 48

         pantalla = 1
         jugando = true

         Qt.callLater(cambiarObjetivo)

         if (sonidoActivo)
             musica.play()
    }

     function tocarObjetivo() {
            if (!jugando || pausado)
                return

            if (tipoObjetivo === 0) {
                estrellas++
                combo++

                if (combo > mejorCombo)
                    mejorCombo = combo

                var ganancia = dificultad === "Difícil" ? 3 : 2

                if (combo >= 5)
                    ganancia += 3
                else if (combo >= 3)
                    ganancia += 1

                puntos += ganancia

                if (sonidoActivo)
                    sonidoEstrella.play()
            } else {
                meteoritos++
                combo = 0
                puntos = Math.max(0, puntos - 3)

                if (sonidoActivo)
                    sonidoMeteorito.play()
            }

            cambiarObjetivo()
        }

        function cambiarPausa() {
            if (!jugando)
                return

            pausado = !pausado

            if (sonidoActivo) {
                if (pausado)
                    musica.pause()
                else
                    musica.play()
            }
        }

        function terminarJuego() {
            if (!jugando)
                return

            jugando = false
            pausado = false
            partidaTerminada = true

            musica.stop()

            registroPuntajes.agregarPartida(
                nombreJugador,
                aliasJugador,
                edadJugador,
                dificultad,
                puntos
            )

            pantalla = 2
        }

        onEtapaChanged: {
            if (jugando && etapa > 1) {
                avisoEtapa = "ETAPA " + etapa + " - MÁS VELOCIDAD"
                cambiarObjetivo()

                if (sonidoActivo)
                    sonidoEtapa.play()

                avisoTimer.restart()
            }
        }

        onSonidoActivoChanged: {
            if (!sonidoActivo)
                musica.stop()
            else if (jugando && !pausado)
                musica.play()
        }

        MediaPlayer {
                id: musica
                source: Qt.resolvedUrl("audio/musica.wav")
                loops: MediaPlayer.Infinite

                audioOutput: AudioOutput {
                    volume: 0.28
                }
            }

            SoundEffect {
                id: sonidoEstrella
                source: Qt.resolvedUrl("audio/estrella.wav")
                volume: 0.5
            }

            SoundEffect {
                id: sonidoMeteorito
                source: Qt.resolvedUrl("audio/meteorito.wav")
                volume: 0.5
            }

            SoundEffect {
                id: sonidoEtapa
                source: Qt.resolvedUrl("audio/etapa.wav")
                volume: 0.5
            }

            Timer {
                   id: cronometro
                   interval: 1000
                   repeat: true
                   running: ventana.jugando && !ventana.pausado

                   onTriggered: {
                       if (ventana.tiempo > 1) {
                           ventana.tiempo--
                       } else {
                           ventana.tiempo = 0
                           ventana.terminarJuego()
                       }
                   }
               }

               Timer {
                   id: movimientoTimer
                   interval: ventana.intervaloObjetivos
                   repeat: true
                   running: ventana.jugando && !ventana.pausado

                   onTriggered: ventana.cambiarObjetivo()
               }

               Timer {
                   id: avisoTimer
                   interval: 1400
                   onTriggered: ventana.avisoEtapa = ""
               }
               StackLayout {
                      anchors.fill: parent
                      currentIndex: ventana.pantalla

                      Item {
                          ColumnLayout {
                              anchors.fill: parent
                              anchors.margins: 20
                              spacing: 9

                              Item {
                                  Layout.fillHeight: true
                              }

                              Label {
                                  text: "★"
                                  color: "#ffd166"
                                  font.pixelSize: 70
                                  Layout.alignment: Qt.AlignHCenter
                              }

                              Label {
                                  text: "ÓRBITA FUGAZ"
                                  color: "white"
                                  font.pixelSize: 27
                                  font.bold: true
                                  Layout.alignment: Qt.AlignHCenter
                              }

                              Label {
                                  text: "Atrapa estrellas, esquiva meteoritos y supera las tres etapas"
                                  color: "#a9bdd8"
                                  wrapMode: Text.WordWrap
                                  horizontalAlignment: Text.AlignHCenter
                                  Layout.fillWidth: true
                              }

                              Label {
                                  text: "Nombre"
                                  color: "white"
                              }

                              TextField {
                                  id: campoNombre
                                  Layout.fillWidth: true
                                  placeholderText: "Nombre del jugador"
                                  maximumLength: 35
                              }

                              Label {
                                  text: "Alias"
                                  color: "white"
                              }

                              TextField {
                                  id: campoAlias
                                  Layout.fillWidth: true
                                  placeholderText: "Nombre para los resultados"
                                  maximumLength: 20
                              }

                              Label {
                                  text: "Edad"
                                  color: "white"
                              }

                              TextField {
                                  id: campoEdad
                                  Layout.fillWidth: true
                                  placeholderText: "Edad"
                                  maximumLength: 3
                                  inputMethodHints: Qt.ImhDigitsOnly

                                  validator: IntValidator {
                                      bottom: 1
                                      top: 999
                                  }
                              }

                              Label {
                                  text: "Dificultad"
                                  color: "white"
                              }

                              ComboBox {
                                  id: campoDificultad
                                  Layout.fillWidth: true
                                  model: ["Fácil", "Normal", "Difícil"]
                                  currentIndex: 1
                              }

                              CheckBox {
                                  text: "Activar música y efectos"
                                  checked: ventana.sonidoActivo
                                  onToggled: ventana.sonidoActivo = checked
                              }

                              Label {
                                  id: mensaje
                                  text: ""
                                  color: "#ff8989"
                                  visible: text.length > 0
                                  Layout.fillWidth: true
                                  wrapMode: Text.WordWrap
                              }

                              Button {
                                  text: "COMENZAR MISIÓN"
                                  Layout.fillWidth: true
                                  highlighted: true

                                  onClicked: {
                                      var nombre = campoNombre.text.trim()
                                      var alias = campoAlias.text.trim()
                                      var edad = Number(campoEdad.text)

                                      if (nombre.length < 2) {
                                          mensaje.text = "Ingresa un nombre válido."
                                          return
                                      }

                                      if (alias.length < 2) {
                                          mensaje.text = "Ingresa un alias válido."
                                          return
                                      }

                                      if (campoEdad.text.trim() === "" ||
                                          !Number.isInteger(edad) ||
                                          edad < 5 || edad > 100) {
                                          mensaje.text = "La edad debe estar entre 5 y 100."
                                          return
                                      }

                                      nombreJugador = nombre
                                      aliasJugador = alias
                                      edadJugador = edad
                                      dificultad = campoDificultad.currentText
                                      mensaje.text = ""

                                      campoNombre.focus = false
                                      campoAlias.focus = false
                                      campoEdad.focus = false

                                      iniciarJuego()
                                  }
                              }

                              Button {
                                  text: "VER HISTORIAL"
                                  flat: true
                                  Layout.fillWidth: true

                                  onClicked: {
                                      partidaTerminada = false
                                      pantalla = 2
                                  }
                              }

                              Item {
                                  Layout.fillHeight: true
                              }
                          }
                      }


                      Item {
                                 ColumnLayout {
                                     anchors.fill: parent
                                     anchors.margins: 15
                                     spacing: 10

                                     Label {
                                         text: "MISIÓN ESPACIAL"
                                         color: "#78dce8"
                                         font.pixelSize: 23
                                         font.bold: true
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     Label {
                                         text: aliasJugador + " · " + dificultad + " · Etapa " + etapa + "/3"
                                         color: "#afc3dd"
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     RowLayout {
                                         Layout.fillWidth: true

                                         Label {
                                             text: "Puntos: " + puntos
                                             color: "#ffd166"
                                             font.pixelSize: 18
                                             font.bold: true
                                             Layout.fillWidth: true
                                         }

                                         Label {
                                             text: tiempo + " s"
                                             color: tiempo <= 5 ? "#ff7474" : "white"
                                             font.pixelSize: 18
                                             font.bold: true
                                         }
                                     }

                                     ProgressBar {
                                         Layout.fillWidth: true
                                         from: 0
                                         to: 30
                                         value: tiempo
                                     }

                                     RowLayout {
                                         Layout.fillWidth: true

                                         Label {
                                             text: "Estrellas: " + estrellas
                                             color: "#ffd166"
                                             Layout.fillWidth: true
                                         }

                                         Label {
                                             text: "Combo: x" + combo
                                             color: "#78dce8"
                                             font.bold: true
                                         }
                                     }

                                     Label {
                                         text: "Velocidad: " + intervaloObjetivos + " ms"
                                         color: "#b6c6dd"
                                         font.pixelSize: 12
                                     }

                                     Rectangle {
                                         id: zonaJuego
                                         Layout.fillWidth: true
                                         Layout.fillHeight: true
                                         radius: 15
                                         color: "#1c2b45"
                                         border.color: "#365074"
                                         clip: true

                                         Repeater {
                                             model: 18

                                             Rectangle {
                                                 required property int index

                                                 width: 2 + index % 3
                                                 height: width
                                                 radius: width / 2
                                                 color: "#adc6ec"
                                                 opacity: 0.5

                                                 x: ((index * 37) % 97) / 100 * zonaJuego.width
                                                 y: ((index * 53) % 93) / 100 * zonaJuego.height
                                             }
                                         }

                                         Rectangle {
                                             id: objetivo
                                             width: ventana.tamañoObjetivo
                                             height: width
                                             radius: width / 2
                                             x: ventana.posicionX
                                             y: ventana.posicionY
                                             visible: ventana.jugando && !ventana.pausado

                                             color: ventana.tipoObjetivo === 0 ? "#ffd166" : "#e85d6b"
                                             border.color: ventana.tipoObjetivo === 0 ? "#fff0af" : "#ff9ba4"
                                             border.width: 3

                                             Label {
                                                 anchors.centerIn: parent
                                                 text: ventana.tipoObjetivo === 0 ? "★" : "☄"
                                                 color: "#19253d"
                                                 font.pixelSize: objetivo.width * 0.6
                                             }

                                             TapHandler {
                                                 onTapped: ventana.tocarObjetivo()
                                             }
                                         }

                                         Label {
                                             anchors.horizontalCenter: parent.horizontalCenter
                                             anchors.top: parent.top
                                             anchors.topMargin: 18

                                             text: ventana.avisoEtapa
                                             visible: ventana.avisoEtapa.length > 0 && !ventana.pausado
                                             color: "#ffd166"
                                             font.pixelSize: 16
                                             font.bold: true
                                         }

                                         Rectangle {
                                             anchors.fill: parent
                                             visible: ventana.pausado
                                             color: "#dd101827"
                                             radius: 15

                                             Column {
                                                 anchors.centerIn: parent
                                                 spacing: 10

                                                 Label {
                                                     text: "JUEGO EN PAUSA"
                                                     color: "white"
                                                     font.pixelSize: 20
                                                     font.bold: true
                                                 }

                                                 Button {
                                                     text: "CONTINUAR"
                                                     anchors.horizontalCenter: parent.horizontalCenter
                                                     onClicked: ventana.cambiarPausa()
                                                 }
                                             }
                                         }
                                     }

                                     RowLayout {
                                         Layout.fillWidth: true

                                         Button {
                                             text: ventana.pausado ? "CONTINUAR" : "PAUSAR"
                                             Layout.fillWidth: true
                                             onClicked: ventana.cambiarPausa()
                                         }

                                         Button {
                                             text: "TERMINAR"
                                             Layout.fillWidth: true
                                             onClicked: ventana.terminarJuego()
                                         }
                                     }
                                 }
                             }

                      Item {
                                 ColumnLayout {
                                     anchors.fill: parent
                                     anchors.margins: 18
                                     spacing: 12

                                     Label {
                                         text: "RESULTADOS"
                                         color: "#78dce8"
                                         font.pixelSize: 27
                                         font.bold: true
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     Label {
                                         text: "Historial de partidas"
                                         color: "#a9bdd8"
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     Label {
                                         text: "Último puntaje: " + ventana.puntos
                                         color: "#ffd166"
                                         font.pixelSize: 20
                                         visible: ventana.partidaTerminada
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     Label {
                                         text: "Mejor combo: " + ventana.mejorCombo
                                         color: "#78dce8"
                                         visible: ventana.partidaTerminada
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     Label {
                                         text: "No hay partidas registradas."
                                         color: "#a9bdd8"
                                         visible: registroPuntajes.cantidad === 0
                                         Layout.alignment: Qt.AlignHCenter
                                     }

                                     ListView {
                                         id: lista
                                         Layout.fillWidth: true
                                         Layout.fillHeight: true
                                         clip: true
                                         spacing: 8
                                         model: registroPuntajes

                                         delegate: Rectangle {
                                             required property string nombre
                                             required property string alias
                                             required property int edad
                                             required property string dificultad
                                             required property int puntos
                                             required property string fecha

                                             width: lista.width
                                             height: 90
                                             radius: 12
                                             color: "#20324e"
                                             border.color: "#3a5274"

                                             ColumnLayout {
                                                 anchors.fill: parent
                                                 anchors.margins: 10
                                                 spacing: 4

                                                 RowLayout {
                                                     Layout.fillWidth: true

                                                     Label {
                                                         text: alias
                                                         color: "white"
                                                         font.bold: true
                                                         font.pixelSize: 17
                                                         Layout.fillWidth: true
                                                         elide: Text.ElideRight
                                                     }

                                                     Label {
                                                         text: puntos + " pts"
                                                         color: "#ffd166"
                                                         font.bold: true
                                                     }
                                                 }

                                                 Label {
                                                     text: nombre + " - " + dificultad + " - " + edad + " años"
                                                     color: "#bdcee4"
                                                     font.pixelSize: 12
                                                     Layout.fillWidth: true
                                                     elide: Text.ElideRight
                                                 }

                                                 Label {
                                                     text: fecha
                                                     color: "#94aac7"
                                                     font.pixelSize: 11
                                                 }
                                             }
                                         }
                                     }

                                     Button {
                                         text: "JUGAR NUEVAMENTE"
                                         highlighted: true
                                         Layout.fillWidth: true

                                         onClicked: {
                                             if (ventana.nombreJugador.length > 0)
                                                 ventana.iniciarJuego()
                                             else
                                                 ventana.pantalla = 0
                                         }
                                     }

                                     Button {
                                         text: "VOLVER AL INICIO"
                                         Layout.fillWidth: true

                                         onClicked: {
                                             ventana.partidaTerminada = false
                                             ventana.pantalla = 0
                                         }
                                     }

                                     Button {
                                         text: "BORRAR HISTORIAL"
                                         flat: true
                                         Layout.fillWidth: true
                                         enabled: registroPuntajes.cantidad > 0
                                         onClicked: confirmarBorrado.open()
                                     }
                                 }
                             }
                         }

                         Dialog {
                             id: confirmarBorrado
                             title: "Borrar historial"
                             modal: true
                             anchors.centerIn: parent
                             standardButtons: Dialog.Yes | Dialog.No

                             onAccepted: registroPuntajes.eliminarHistorial()

                             Label {
                                 text: "¿Deseas eliminar todas las partidas?"
                                 wrapMode: Text.WordWrap
                             }
                         }
}
