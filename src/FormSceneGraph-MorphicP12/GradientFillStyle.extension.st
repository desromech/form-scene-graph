Extension { #name : 'GradientFillStyle' }

{ #category : '*FormSceneGraph-MorphicP12' }
GradientFillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	self isRadialFill ifTrue: [
		 ^ builder rectangle: aRectangle radialGradientCenter: self origin
				innerRadius: 0 clipRadius: 0
				outerRadius: self direction y clipRadius: self direction y
				colorRamp: colorRamp
	] ifFalse: [
		^ builder rectangle: aRectangle linearGradientStart: self origin end: self origin + self direction colorRamp: colorRamp
	].
]
