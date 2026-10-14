
; ============================================
; RAPCON - CALCULO DE COORDENADAS 3D
; ============================================
;
; Modulo responsavel pelos calculos
; geometricos utilizados na geracao
; de pontos do projeto RAPCON.
;
; Desenvolvido em AutoLISP.
;
; ============================================

(defun rapcon-calcular-coordenadas
  (pontoBase direcao distancia diferencaCota
   / angulo novoX novoY novoZ)

  ; Determinacao do angulo de referencia
  (setq angulo
    (angle pontoBase direcao)
  )

  ; Calculo da coordenada X
  (setq novoX
    (+ (car pontoBase)
       (* distancia (cos angulo)))
  )

  ; Calculo da coordenada Y
  (setq novoY
    (+ (cadr pontoBase)
       (* distancia (sin angulo)))
  )

  ; Calculo da elevacao Z
  (setq novoZ
    (+ (caddr pontoBase) diferencaCota)
  )

  ; Retorno das coordenadas calculadas
  (list novoX novoY novoZ)
)
