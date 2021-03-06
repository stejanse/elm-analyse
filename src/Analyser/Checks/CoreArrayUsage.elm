module Analyser.Checks.CoreArrayUsage exposing (checker)

import Analyser.Checks.Base exposing (Checker, keyBasedChecker)
import Analyser.Configuration exposing (Configuration)
import Analyser.FileContext exposing (FileContext)
import Analyser.Messages.Range as Range exposing (RangeContext)
import Analyser.Messages.Types exposing (Message, MessageData(CoreArrayUsage), newMessage)
import Elm.Syntax.Module exposing (Import)


checker : Checker
checker =
    { check = scan
    , shouldCheck = keyBasedChecker [ "CoreArrayUsage" ]
    }


scan : RangeContext -> FileContext -> Configuration -> List Message
scan rangeContext fileContext _ =
    fileContext.ast.imports
        |> List.filter isArrayImport
        |> List.map (.range >> Range.build rangeContext >> CoreArrayUsage fileContext.path)
        |> List.map (newMessage [ ( fileContext.sha1, fileContext.path ) ])
        |> List.take 1


isArrayImport : Import -> Bool
isArrayImport { moduleName } =
    moduleName == [ "Array" ]
