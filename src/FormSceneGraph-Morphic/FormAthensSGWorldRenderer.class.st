"
I am a scene graph based world renderer that uses the Athens renderer.
"
Class {
	#name : #FormAthensSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #hooks }
FormAthensSGWorldRenderer >> adjustSurfaceDamageRectangle: rectangle [
	^ rectangle origin floor corner: (rectangle corner + (1@1)) ceiling
]

{ #category : #operations }
FormAthensSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	| renderer |
	renderer := self osWindowRenderer.
	renderer drawDuring: [ :canvas |
		canvas clipBy: damageRectangle during: [
			canvas paintMode clear.
			canvas
				setPaint: Color transparent;
				drawShape: damageRectangle.

			canvas paintMode default.
			FormSGAthensRenderer new
				surfaceScaleFactor: self scaleFactor;
				render: newSceneGraph on: canvas.
		].
	].
	renderer updateRectangle: damageRectangle.
	renderer present
]

{ #category : #activation }
FormAthensSGWorldRenderer >> initialize [
	super initialize.
	
	self flag: 'FIXME: workaround a VM bug. The SurfacePlugin defines methods that are called via primitives and the FFI. If these methods are called first via the FFI, the plugin module is never initialized which causes a segmentation fault by not setting the interpreter proxy in the plugin. We create an OSSDL2ExternalForm here to to avoid this border case.'.
	OSSDL2ExternalForm extent: 1@1 depth: 32 bits: ExternalAddress null.
]

{ #category : #initialization }
FormAthensSGWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ osWindow renderer ifNil: [
		osWindow newAthensRenderer.
		osWindow renderer
	].
	
]
