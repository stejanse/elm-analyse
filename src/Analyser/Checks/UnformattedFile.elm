module Analyser.Checks.UnformattedFile exposing (checker)

import Analyser.Checks.Base exposing (Checker, keyBasedChecker)
import Analyser.Configuration exposing (Configuration)
import Analyser.FileContext exposing (FileContext)
import Analyser.Messages.Range exposing (RangeContext)
import Analyser.Messages.Types exposing (Message, MessageData(UnformattedFile), newMessage)


checker : Checker
checker =
    { check = scan
    , shouldCheck = keyBasedChecker [ "UnformattedFile" ]
    }


scan : RangeContext -> FileContext -> Configuration -> List Message
scan _ fileContext _ =
    if fileContext.formatted then
        []
    else
        [ newMessage
            [ ( fileContext.sha1, fileContext.path ) ]
            (UnformattedFile fileContext.path)
        ]
