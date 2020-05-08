'' Go to Tools > Macro > Visual Basic Editor, select Insert > Module, copy
'' following text in the blank page. Then choose File > Close > Return to PPT,
'' go to Tools > Macro > Macros, then select AddProcessBar and press Execute.

Sub AddProgressBar()
  On Error Resume Next
    With ActivePresentation
      sHeight = .PageSetup.SlideHeight - 3
      n = 0
      j = 0

      For i = 1 To .Slides.Count
        If .Slides(i).SlideShowTransition.Hidden Then j = j + 1
      Next i:

      For i = 2 To .Slides.Count
        .Slides(i).Shapes("progressBar").Delete
        If .Slides(i).SlideShowTransition.Hidden = msoFalse Then
          Set slider = .Slides(i).Shapes.AddShape(msoShapeRectangle, 0, sHeight, (i - n) * .PageSetup.SlideWidth / (.Slides.Count - j), 3)
          With slider
            .Fill.ForeColor.RGB = ActivePresentation.SlideMaster.ColorScheme.Colors(ppFill).RGB
            .Name = "progressBar"
          End With
        Else
          n = n + 1
        End If
      Next i:
    End With
End Sub

Sub RemoveProgressBar()
  On Error Resume Next
    With ActivePresentation
      For i = 1 To .Slides.Count
        .Slides(i).Shapes("progressBar").Delete
      Next i:
    End With
End Sub
