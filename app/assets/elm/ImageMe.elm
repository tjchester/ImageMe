module ImageMe exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Navigation

main : Program Never Model Msg
main =
  Navigation.program UrlChange
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }


-- MODEL


type alias Model =
  { hsize : String
  , vsize : String
  , text : String
  , bgcolor: String
  , fgcolor: String
  , url: String
  , base_url: Navigation.Location
  }


init : Navigation.Location -> ( Model, Cmd Msg)
init location =
  ( 
    Model 
      
        "300" 
        "250" 
        "300x250" 
        "cccccc" 
        "ffffff" 
        (location.href ++ "300x250/cccccc/ffffff?text=300x250")
        location
       
    , Cmd.none
  )


-- UPDATE


type Msg
  = HSize String
  | VSize String
  | Text String
  | BgColor String
  | FgColor String
  | Generate
  | Reset
  | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of
    HSize value -> 
      ({ model | hsize = value, text = value ++ "x" ++ model.vsize }, Cmd.none)

    VSize value -> 
      ({ model | vsize = value, text = model.hsize ++ "x" ++ value }, Cmd.none)

    Text value -> 
      ({ model | text = value }, Cmd.none)

    BgColor value -> 
      ({ model | bgcolor = value }, Cmd.none)

    FgColor value -> 
      ({ model | fgcolor = value }, Cmd.none)

    Generate ->
      (generateUrl model , Cmd.none)

    Reset ->
      ({ model | hsize = "300", vsize = "250", text = "300x250", bgcolor = "cccccc", fgcolor = "ffffff" }, Cmd.none)

    UrlChange location ->
      ( model , Cmd.none)


-- VIEW


generateUrl : Model -> Model
generateUrl model =
  let 
    new_url = 
      model.base_url.href
      ++ model.hsize
      ++ "x" 
      ++ model.vsize
      ++ "/" 
      ++ model.bgcolor 
      ++ "/" 
      ++ model.fgcolor 
      ++ "?text=" 
      ++ model.text
  in
    { model | url = new_url}


view : Model -> Html Msg
view model =
  div [ class "container" ]
  [
    div [ class "row"]
    [
      div [ class "col-md-2 col-md-offset-2" ] [ viewForm model ]
    , div [ class "col-md-6" ] [ viewImage model.url ]
    ]
  ]


viewForm : Model -> Html Msg
viewForm model =
  div [ class "form-horizontal" ]
    [
      div [ class "form-group" ]
      [
        label [ class "control-label"] [ text "Horizontal Size" ], 
        input [ class "form-control", type_ "text", placeholder model.hsize, value model.hsize, onInput HSize ] []
      ]
      , div [ class "form-group" ] 
      [
         label [ class "control-label"] [ text "Vertical Size"], 
         input [ class "form-control", type_ "text", placeholder model.vsize, value model.vsize, onInput VSize ] []
      ]
      , div [ class "form-group" ] 
      [
          label [ class "control-label"] [ text "Text Message"], 
          input [ class "form-control", type_ "text", placeholder model.text, value model.text, onInput Text ] []
      ]
      , div [ class "form-group" ] 
      [
          label [ class "control-label"] [ text "Background Color"], 
          input [ class "form-control text-uppercase", type_ "text", placeholder model.bgcolor, value model.bgcolor, onInput BgColor ] []
      ]
      , div [ class "form-group" ] 
      [
          label [ class "control-label"] [ text "Foreground Color" ], 
          input [ class "form-control text-uppercase", type_ "text", placeholder model.fgcolor, value model.fgcolor, onInput FgColor ] []
      ]
      , div [ class "form-group" ]
      [
          button [ class "btn btn-default pull-left", onClick Reset ] [ text "Reset" ]
        , button [ class "btn btn-primary pull-right", onClick Generate ] [ text "Create Image" ]
      ]
    ]


viewImage : String -> Html Msg
viewImage url =
  div [ class "panel panel-info"]
    [
      div [ class "panel-heading"] 
      [ 
        div [ class "panel-title" ] [ text ("URL: " ++ url) ] 
      ]
    , div [ class "panel-body" ] [ img [ class "center-block", src url ] [ ] ]
    ]
