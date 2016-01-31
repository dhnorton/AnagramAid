'From Cuis 4.2 of 25 July 2013 [latest update: #2676] on 31 January 2016 at 2:15:34.896426 pm'!
!classDefinition: #Character category: #'Kernel-Text'!
Object subclass: #Character
	instanceVariableNames: 'value'
	classVariableNames: 'CharacterTable ClassificationTable LetterBits LowercaseBit UnaccentedTable UnicodeCodePoints UppercaseBit'
	poolDictionaries: ''
	category: 'Kernel-Text'!
!Character commentStamp: '<historical>' prior: 0!
I represent a character by storing its associated Latin-9 code (ISO 8859-15). My instances are created uniquely, so that all instances of a character ($R, for example) are identical.!


!Character methodsFor: 'accessing' stamp: 'jmv 12/25/2013 16:17'!
asciiValue
	"Answer the value of the receiver that represents its ISO 8859-15 encoding.
	This is the same as ASCII for the first 128 characters."

	^self value! !

!Character methodsFor: 'accessing'!
digitValue
	"Answer 0-9 if the receiver is $0-$9, 10-35 if it is $A-$Z, and < 0 
	otherwise. This is used to parse literal numbers of radix 2-36."

	value <= $9 asciiValue 
		ifTrue: [^value - $0 asciiValue].
	value >= $A asciiValue 
		ifTrue: [value <= $Z asciiValue ifTrue: [^value - $A asciiValue + 10]].
	^ -1! !

!Character methodsFor: 'accessing' stamp: 'jmv 1/25/2014 13:44'!
iso8859s15Code
	"Answer the value of the receiver that represents its ISO 8859-15 (Latin-9) encoding.
	Any implementation of Character like object beyond ISO-8859-15 should answer nil.
	Senders, please consider that this method might answer nil.
	See #iso8859s15CodeForUnicodeCodePoint:"

	^ self value! !

!Character methodsFor: 'accessing' stamp: 'jmv 10/7/2010 16:26'!
unicodeCodePoint
	"
	self assert: $A unicodeCodePoint hex = '16r41'.
	self assert: $§ unicodeCodePoint hex = '16r20AC'.
	"
	^UnicodeCodePoints at: value+1! !

!Character methodsFor: 'accessing' stamp: 'jmv 12/25/2013 16:17'!
value
	"Answer the value of the receiver that represents its ISO 8859-15 (Latin-9) encoding."

	^value! !


!Character methodsFor: 'comparing' stamp: 'jmv 10/6/2010 18:18'!
< aCharacter 
	"Compare with the standard case sensitive collation order.
	This stuff should be in Character and not in String..."

	^String does: self collateBefore: aCharacter! !

!Character methodsFor: 'comparing'!
= aCharacter 
	"Primitive. Answer true if the receiver and the argument are the same
	object (have the same object pointer) and false otherwise. Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 110>
	^self == aCharacter! !

!Character methodsFor: 'comparing' stamp: 'jmv 10/6/2010 18:18'!
> aCharacter 
	"Compare with the standard case sensitive collation order.
	This stuff should be in Character and not in String..."

	^String does: self collateAfter: aCharacter! !

!Character methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^value! !


!Character methodsFor: 'testing' stamp: 'jmv 12/8/2009 09:46'!
canBeGlobalVarInitial
	^self isUppercase! !

!Character methodsFor: 'testing' stamp: 'jmv 6/14/2011 22:53'!
isAccented
	^self isLetter and: [ self asUnaccented ~~ self ]! !

!Character methodsFor: 'testing'!
isAlphaNumeric
	"Answer whether the receiver is a letter or a digit."

	^self isLetter or: [self isDigit]! !

!Character methodsFor: 'testing'!
isDigit
	"Answer whether the receiver is a digit."

	^value >= 48 and: [value <= 57]! !

!Character methodsFor: 'testing' stamp: 'dgd 8/24/2003 14:50'!
isLetter
	"Answer whether the receiver is a letter."

	^ (ClassificationTable at: value + 1)
		anyMask: LetterBits! !

!Character methodsFor: 'testing' stamp: 'jmv 3/13/2012 15:41'!
isLineSeparator
	"Answer whether the receiver is a line separator character:
	cr, line feed, or form feed."

	value = 10 ifTrue: [^true].	"line feed"
	value = 13 ifTrue: [^true].	"cr"
	value = 12 ifTrue: [^true].	"form feed"
	^false! !

!Character methodsFor: 'testing' stamp: 'dgd 8/24/2003 14:51'!
isLowercase
	"Answer whether the receiver is a lowercase letter.
	(The old implementation answered whether the receiver is not an uppercase letter.)"

	^ ((ClassificationTable at: value + 1)
		bitAnd: LowercaseBit)
		= LowercaseBit! !

!Character methodsFor: 'testing'!
isSeparator
	"Answer whether the receiver is one of the separator characters--space, 
	cr, tab, line feed, or form feed."

	value = 32 ifTrue: [^true].	"space"
	value = 13 ifTrue: [^true].	"cr"
	value = 9 ifTrue: [^true].	"tab"
	value = 10 ifTrue: [^true].	"line feed"
	value = 12 ifTrue: [^true].	"form feed"
	^false! !

!Character methodsFor: 'testing' stamp: 'di 4/3/1999 00:38'!
isSpecial
	"Answer whether the receiver is one of the special characters"

	^'+-/\*~<>=@,%|&?!!' includes: self! !

!Character methodsFor: 'testing' stamp: 'jmv 6/14/2011 22:53'!
isUnaccented
	^self isLetter and: [ self asUnaccented == self ]! !

!Character methodsFor: 'testing' stamp: 'dgd 8/24/2003 14:52'!
isUppercase
	"Answer whether the receiver is an uppercase letter.
	(The old implementation answered whether the receiver is not a lowercase letter.)"

	^ ((ClassificationTable at: value + 1)
		bitAnd: UppercaseBit)
		= UppercaseBit! !

!Character methodsFor: 'testing' stamp: 'jmv 11/16/2015 15:07'!
isValidInIdentifiers
	"Can c be part of an identifier? (unary or keyword selector, or variable name)"

	^self isAlphaNumeric or: [ #( $_ $` ) statePointsTo: self ]! !

!Character methodsFor: 'testing' stamp: 'jmv 11/16/2015 14:56'!
isValidStartOfIdentifiers
	"Can c be the first character of an identifier? (unary or keyword selector, or variable name)"

	^self isLetter or: [ self  = $_ ]! !

!Character methodsFor: 'testing' stamp: 'jmv 10/6/2010 17:27'!
isVowel
	"Answer whether the receiver is one of the vowels, AEIOU, in upper or 
	lower case, and with various diacritical marks."

	^Character vowels includes: self! !

!Character methodsFor: 'testing' stamp: 'jmv 11/16/2015 14:51'!
tokenish
	"Answer whether the receiver is a valid token-character--letter, digit, or 
	colon."

	^self isValidInIdentifiers or: [self = $:]! !


!Character methodsFor: 'copying' stamp: 'jmv 5/20/2011 10:51'!
shallowCopy
	"Answer with the receiver because Characters are unique."! !


!Character methodsFor: 'printing'!
hex
	^ String with: ('0123456789ABCDEF' at: value//16+1)
			with:  ('0123456789ABCDEF' at: value\\16+1)! !

!Character methodsFor: 'printing'!
isLiteral

	^true! !

!Character methodsFor: 'printing'!
printOn: aStream

	aStream nextPut: $$.
	aStream nextPut: self! !

!Character methodsFor: 'printing'!
storeOn: aStream
	"Character literals are preceded by '$'."

	aStream nextPut: $$; nextPut: self! !


!Character methodsFor: 'converting'!
asCharacter
	"Answer the receiver itself."

	^self! !

!Character methodsFor: 'converting' stamp: 'jmv 12/25/2013 16:18'!
asInteger
	"Answer the value of the receiver."

	^self value! !

!Character methodsFor: 'converting' stamp: 'dgd 8/24/2003 14:53'!
asLowercase
	"If the receiver is uppercase, answer its matching lowercase Character."
	
	^ Character
		value: ((ClassificationTable at: value + 1)
				bitAnd: 255)! !

!Character methodsFor: 'converting' stamp: 'sma 3/11/2000 17:21'!
asString
	^ String with: self! !

!Character methodsFor: 'converting' stamp: 'raa 5/26/2001 09:54'!
asSymbol 
	"Answer a Symbol consisting of the receiver as the only element."

	^Symbol internCharacter: self! !

!Character methodsFor: 'converting' stamp: 'tk 9/4/2000 12:05'!
asText
	^ self asString asText! !

!Character methodsFor: 'converting' stamp: 'jmv 6/14/2011 22:43'!
asUnaccented
	"
	$A asUnaccented
	$¡ asUnaccented
	(0 to: 255) collect: [ :i | (Character value: i) asUnaccented ]
	(0 to: 255) collect: [ :i | (Character value: i) asUnaccented  asLowercase]
	"
	^ Character
		value: (UnaccentedTable at: value + 1)! !

!Character methodsFor: 'converting' stamp: 'dgd 8/24/2003 14:53'!
asUppercase
	"If the receiver is lowercase, answer its matching uppercase Character."
	
	^ Character
		value: (((ClassificationTable at: value + 1)
				bitShift: -8)
				bitAnd: 255)! !

!Character methodsFor: 'converting'!
to: other
	"Answer with a collection in ascii order -- $a to: $z"
	^ (self asciiValue to: other asciiValue) collect:
				[:ascii | Character value: ascii]! !

!Character methodsFor: 'converting' stamp: 'jmv 11/7/2013 19:01'!
withDiacriticalMark: anUnicodeCodePoint
	"Answer the character resulting from adding a diacritical mark (accent) to a letter.
	If the result is unsupported in ISO 8859-15, answer the receiver.
	Supported diacritical marks are:
		U+0300 	COMBINING GRAVE ACCENT
		U+0301 	COMBINING ACUTE ACCENT
		U+0302 	COMBINING CIRCUMFLEX ACCENT
		U+0303 	COMBINING TILDE
		U+0308 	COMBINING DIAERESIS
		U+030A 	COMBINING RING ABOVE
		U+030C 	COMBINING CARON
		$a withDiacriticalMark: 16r301
		$N withDiacriticalMark: $~
		$Z withDiacriticalMark: $v
		
		invalid:
		$9 withDiacriticalMark:$v
		$A withDiacriticalMark: $v
		$¡ withDiacriticalMark: $v
		$A withDiacriticalMark: 1244
		"
	| answer i |
	i _ ((anUnicodeCodePoint isNumber
			ifTrue: [#(16r300 16r301 16r302 16r303 16r308 16r30A 16r30C)]
			ifFalse: [#($` $' $^ $~ $" $∞ $v)]) indexOf: anUnicodeCodePoint
				) + 1.
	answer _ (Character accentedLetters detect: [ :group | group first = self ] ifNone: [ ^self ]) at: i.
	^answer = $- ifFalse: [answer] ifTrue: [self]! !


!Character methodsFor: 'object fileIn' stamp: 'tk 1/17/2000 11:27'!
comeFullyUpOnReload: smartRefStream
	"Use existing an Character.  Don't use the new copy."

	^ self class value: value! !


!Character methodsFor: '*fileman-core-testing' stamp: 'mu 3/2/2007 21:34'!
isDriveLetter
	^'ABCDEFGHIJKLMNOPQRSTUVWXYZ' includes: self asUppercase
	! !

!Character methodsFor: '*fileman-core-testing' stamp: 'mu 3/3/2007 09:45'!
isDriveSeparator
	^self == $:
	! !

!Character methodsFor: '*fileman-core-testing' stamp: 'mu 3/3/2007 19:37'!
isPathSeparator
	self = $\ ifTrue: [^true].
	self = $: ifTrue: [^true].
	self = $/ ifTrue: [^true].
	^false! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Character class' category: #'Kernel-Text'!
Character class
	instanceVariableNames: ''!

!Character class methodsFor: 'class initialization' stamp: 'jmv 11/7/2013 18:33'!
accentedLetters
	"Answer all letters with all possible accents (combining diacritical marks).
	Order of this array is:
		unaccented
		U+0300 	COMBINING GRAVE ACCENT
		U+0301 	COMBINING ACUTE ACCENT
		U+0302 	COMBINING CIRCUMFLEX ACCENT
		U+0303 	COMBINING TILDE
		U+0308 	COMBINING DIAERESIS
		U+030A 	COMBINING RING ABOVE
		U+030C 	COMBINING CARON
	Do not include letters that can't have any accent in ISO 8859-15
	Denote unsupported combinations (for example A with caron, or N with accute accent) by a $-"
	^#(
		'A¿¡¬√ƒ≈-'
		'a‡·‚„‰Â-'
		'E»… -À--'
		'eËÈÍ-Î--'
		'IÃÕŒ-œ--'
		'iÏÌÓ-Ô--'
		'O“”‘’÷--'
		'oÚÛÙıˆ--'
		'UŸ⁄€-‹--'
		'u˘˙˚-¸--'
		'N---—---'
		'n---Ò---'
		'S------¶'
		's------®'
		'Y-›--æ--'
		'y-˝--ˇ--'
		'Z------¥'
		'z------∏'
	).! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 12/14/2015 23:54'!
initClassCachedState
	"Create the table of unique Characters.
	Character initialize
	"
	self initializeClassificationTable.
	self initializeUnicodeCodePoints! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 12/14/2015 23:54'!
initialize
	"Create the table of unique Characters.
	Character initialize
	"
	self initClassCachedState! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 6/14/2011 20:55'!
initializeClassificationTable
	"Initialize the classification table. The classification table is a
	compact encoding of upper and lower cases of characters with
		- bits 0-7: The lower case value of this character.
		- bits 8-15: The upper case value of this character.
		- bit 16: lowercase bit (e.g., isLowercase == true)
		- bit 17: uppercase bit (e.g., isUppercase == true).
	The UnaccentedTable holds for each numeric value, the corresponding unaccented character"

	LowercaseBit _ 1 bitShift: 16.
	UppercaseBit _ 1 bitShift: 17.

	"Initialize the letter bits (e.g., isLetter == true)"
	LetterBits _ LowercaseBit bitOr: UppercaseBit.

	ClassificationTable _ Array new: 256.
	UnaccentedTable _ ByteArray new: 256.
	"Initialize the defaults (neither lower nor upper case)"
	0 to: 255 do: [ :i |
		ClassificationTable at: i+1 put: (i bitShift: 8) + i.
		UnaccentedTable at: i+1 put: i].

	"Initialize character pairs (upper-lower case)"
	Character uppercaseLowercaseAndUnaccentedLetters do: [ :group |
		| uppercase lowercase unaccentedUppercase unaccentedLowercase |
		group size > 1 ifTrue: [
			uppercase _ group first asciiValue.
			lowercase _ group second asciiValue.
			ClassificationTable at: uppercase+1 put: (uppercase bitShift: 8) + lowercase + UppercaseBit.
			ClassificationTable at: lowercase+1 put: (uppercase bitShift: 8) + lowercase + LowercaseBit.
			group size > 2
				ifTrue: [
					unaccentedUppercase _ group third asciiValue.
					unaccentedLowercase _ group fourth asciiValue.
					UnaccentedTable at: uppercase+1 put: unaccentedUppercase.
					UnaccentedTable at: lowercase+1 put: unaccentedLowercase ].
		] ifFalse: [
			lowercase _ group first asciiValue.
			ClassificationTable at: lowercase+1 put: (lowercase bitShift: 8) + lowercase + LowercaseBit.
		]
	]! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 11/30/2015 16:25'!
initializeUnicodeCodePoints
	"
	String streamContents: [ :strm | 28 to: 255 do: [ :i | strm nextPut: (Character value: i) ]]
	"


	"Initialize the table of Unicode code points"
	UnicodeCodePoints _ Array new: 256.
	0 to: 255 do: [ :code |
		UnicodeCodePoints at: code + 1 put: code ].
	
	"The following codes are different in ISO 8859-15 from those in ISO 8859-1,
	so the character code is not equal to the Unicode code point"
	UnicodeCodePoints at: 16rA4+1 put: 16r20AC.		"euro sign"
	UnicodeCodePoints at: 16rA6+1 put: 16r160.		"latin capital letter S with caron"
	UnicodeCodePoints at: 16rA8+1 put: 16r161.		"latin small letter s with caron"
	UnicodeCodePoints at: 16rB4+1 put: 16r17D.		"latin capital letter Z with caron"
	UnicodeCodePoints at: 16rB8+1 put: 16r17E.		"latin small letter z with caron"
	UnicodeCodePoints at: 16rBC+1 put: 16r152.		"latin capital ligature OE"
	UnicodeCodePoints at: 16rBD+1 put: 16r153.		"latin small ligature oe"
	UnicodeCodePoints at: 16rBE+1 put: 16r178.		"latin capital letter Y with diaeresis"

	UnicodeCodePoints at: 16r80+1 put: 16r2200.		"FOR ALL"
	UnicodeCodePoints at: 16r81+1 put: 16r2202.		"PARTIAL DIFFERENTIAL"
	UnicodeCodePoints at: 16r82+1 put: 16r2203.		"THERE EXISTS"
	UnicodeCodePoints at: 16r83+1 put: 16r2204.		"THERE DOES NOT EXIST"
	UnicodeCodePoints at: 16r84+1 put: 16r2205.		"EMPTY SET"
	UnicodeCodePoints at: 16r85+1 put: 16r221E.		"INFINITY"
	UnicodeCodePoints at: 16r86+1 put: 16r2102.		"DOUBLE-STRUCK CAPITAL C"
	UnicodeCodePoints at: 16r87+1 put: 16r210D.		"DOUBLE-STRUCK CAPITAL H"
	UnicodeCodePoints at: 16r88+1 put: 16r2115.		"DOUBLE-STRUCK CAPITAL N"
	UnicodeCodePoints at: 16r89+1 put: 16r2119.		"DOUBLE-STRUCK CAPITAL P"
	UnicodeCodePoints at: 16r8A+1 put: 16r211A.		"DOUBLE-STRUCK CAPITAL Q"
	UnicodeCodePoints at: 16r8B+1 put: 16r211D.		"DOUBLE-STRUCK CAPITAL R"
	UnicodeCodePoints at: 16r8C+1 put: 16r2124.		"DOUBLE-STRUCK CAPITAL Z"
	UnicodeCodePoints at: 16r8D+1 put: 16r2135.		"ALEF SYMBOL"
	UnicodeCodePoints at: 16r8E+1 put: 16r2A00.		"N-ARY CIRCLED DOT OPERATOR"
	UnicodeCodePoints at: 16r8F+1 put: 16r2A01.		"N-ARY CIRCLED PLUS OPERATOR"
	UnicodeCodePoints at: 16r90+1 put: 16r2A02.		"N-ARY CIRCLED TIMES OPERATOR"
	UnicodeCodePoints at: 16r91+1 put: 16r2211.		"N-ARY SUMMATION"
	UnicodeCodePoints at: 16r92+1 put: 16r222B.		"INTEGRAL"
	UnicodeCodePoints at: 16r93+1 put: 16r2A15.		"INTEGRAL AROUND A POINT OPERATOR"
	UnicodeCodePoints at: 16r94+1 put: 16r2260.		"NOT EQUAL TO"
	UnicodeCodePoints at: 16r95+1 put: 16r2261.		"IDENTICAL TO"
	UnicodeCodePoints at: 16r96+1 put: 16r2262.		"NOT IDENTICAL TO"
	UnicodeCodePoints at: 16r97+1 put: 16r2263.		"STRICTLY EQUIVALENT TO"
	UnicodeCodePoints at: 16r98+1 put: 16r2264.		"LESS-THAN OR EQUAL TO"
	UnicodeCodePoints at: 16r99+1 put: 16r2265.		"GREATER-THAN OR EQUAL TO"
	UnicodeCodePoints at: 16r9A+1 put: 16r2266.		"LESS-THAN OVER EQUAL TO"
	UnicodeCodePoints at: 16r9B+1 put: 16r2267.		"GREATER-THAN OVER EQUAL TO"
	UnicodeCodePoints at: 16r9C+1 put: 16r2268.		"LESS-THAN BUT NOT EQUAL TO"
	UnicodeCodePoints at: 16r9D+1 put: 16r2269.		"GREATER-THAN BUT NOT EQUAL TO"
	UnicodeCodePoints at: 16r9E+1 put: 16r2218.		"RING OPERATOR"
	UnicodeCodePoints at: 16r9F+1 put: 16r2219.		"BULLET OPERATOR"! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 12/18/2015 16:12'!
releaseClassCachedState

"	LowercaseBit _ nil."
"	UppercaseBit _ nil."

"	LetterBits _ nil."

"	ClassificationTable _ nil."
	UnaccentedTable _ nil.
	
	UnicodeCodePoints _ nil! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 6/14/2011 20:22'!
uppercaseLowercaseAndUnaccentedLetters
	"Answer all uppercase and lowercase letters in standard collation order.
	For accented characters, include the non-accented ones.
	Note that $ﬂ is 'LATIN SMALL LETTER SHARP S' and ISO 8859-15 doesn't have an uppercase version."
	^#(
		'Aa' '¿‡Aa' '¡·Aa' '¬‚Aa' '√„Aa' 'ƒ‰Aa' '≈ÂAa'
		'Bb' 'Cc' '«Á' 'Dd'
			'Ee' '»ËEe' '…ÈEe' ' ÍEe' 'ÀÎEe'
		'Ff' 'Gg' 'Hh'
			'Ii' 'ÃÏIi' 'ÕÌIi' 'ŒÓIi' 'œÔIi'
		'Jj' 'Kk' 'Ll' 'Mm' 'Nn' '—Ò'
			'Oo' '“ÚOo' '”ÛOo' '‘ÙOo' '’ıOo' '÷ˆOo'
		'Pp' 'Qq' 'Rr'
			'Ss' '¶®Ss'
		'Tt'
			'Uu' 'Ÿ˘Uu' '⁄˙Uu' '€˚Uu' '‹¸Uu'
		'Vv' 'Ww' 'Xx'
			'Yy' '›˝Yy' 'æˇYy'
			'Zz' '¥∏Zz' 
		'∆Ê' '–' 'ÿ¯' 'ﬁ˛' 'ﬂ' 'ºΩ'
	).! !

!Character class methodsFor: 'class initialization' stamp: 'jmv 10/6/2010 17:26'!
vowels
	"Answer a String with all the vowels"
	
	^'Aa¿‡¡·¬‚√„ƒ‰≈ÂEe»Ë…È ÍÀÎIiÃÏÕÌŒÓœÔOo“Ú”Û‘Ù’ı÷ˆUuŸ˘⁄˙€˚‹¸'! !


!Character class methodsFor: 'instance creation' stamp: 'ls 8/15/1998 06:56'!
allCharacters
	^ (0 to: 255)
		collect: [:v | Character value: v]

	
! !

!Character class methodsFor: 'instance creation'!
digitValue: x 
	"Answer the Character whose digit value is x. For example, answer $9 for 
	x=9, $0 for x=0, $A for x=10, $Z for x=35."

	| index |
	index _ x asInteger.
	^CharacterTable at: 
		(index < 10
			ifTrue: [48 + index]
			ifFalse: [55 + index])
		+ 1! !

!Character class methodsFor: 'instance creation'!
new
	"Creating new characters is not allowed."

	self error: 'cannot create new characters'! !

!Character class methodsFor: 'instance creation' stamp: 'jmv 4/28/2011 15:35'!
safeValue: asciiCodeOrCodePoint 
	"Answer the Character whose value is anInteger.
	Handle unicode code points > 255 without errors, trying to answer something reasonable"

	"Note: senders of #value:or: in '1002-RTFParser.cs' has many automatic conversion to ISO-8859-15 characters, that would be valuable here."
	(#(16r2019 16r201B) includes: asciiCodeOrCodePoint) ifTrue: [
		^$' ].
	(#(16r201C 16r201D 16r201F) includes: asciiCodeOrCodePoint) ifTrue: [
		^$" ].
	^(self unicodeCodePoint: asciiCodeOrCodePoint)
		ifNil: [Character value: 255 ]! !

!Character class methodsFor: 'instance creation'!
separators
	^ #(32 "space"
		13 "cr"
		9 "tab"
		10 "line feed"
		12 "form feed")
		collect: [:v | Character value: v]

	
! !

!Character class methodsFor: 'instance creation' stamp: 'jmv 2/7/2013 22:32'!
unicodeCodePoint: codePoint
	"
	Answer nil if the Unicode codePoint is not a valid ISO 8859-15 character
	
	self assert: (Character unicodeCodePoint: 16r41) = $A.
	self assert: (Character unicodeCodePoint: 16r20AC) = $§.
	"
	^ (self iso8859s15CodeForUnicodeCodePoint: codePoint)
		ifNotNil: [ :code | Character value: code ]! !

!Character class methodsFor: 'instance creation'!
value: anInteger 
	"Answer the Character whose value is anInteger."

	^CharacterTable at: anInteger + 1! !


!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 11/30/2015 16:21'!
arrowDown
	"
	Character arrowDown
	"
	^ self value: 31! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 11/30/2015 16:21'!
arrowLeft
	"
	Character arrowLeft
	"
	^ self value: 28! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 11/30/2015 16:22'!
arrowRight
	"
	Character arrowRight
	"
	^ self value: 29! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 11/30/2015 16:22'!
arrowUp
	"
	Character arrowUp
	"
	^ self value: 30! !

!Character class methodsFor: 'accessing untypeable characters'!
backspace
	"Answer the Character representing a backspace."

	^self value: 8! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 8/28/2013 10:25'!
cr
	"Answer the Character representing a carriage return."

	^self value: 13! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 8/28/2013 10:26'!
crCharacter
	"Answer the Character representing a carriage return."
	"Deprecated. To be removed soon. Please use #cr"

	^self cr! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'NS 7/11/2000 09:19'!
delete
	^ self value: 127! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'NS 7/11/2000 09:21'!
end
	^ self value: 4! !

!Character class methodsFor: 'accessing untypeable characters'!
enter
	"Answer the Character representing enter."

	^self value: 3! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'ls 9/2/1999 08:06'!
escape
	"Answer the ASCII ESC character"

	^self value: 27! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 3/30/2010 09:19'!
euro
	"The Euro currency sign, that E with two dashes.
	Cuis uses ISO Latin 9 (ISO 8859-15) character encoding.
	Each character is 1 byte"

	^ Character value: 164! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'NS 7/11/2000 09:21'!
home
	^ self value: 1! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'NS 7/11/2000 09:19'!
insert
	^ self value: 5! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 8/28/2013 10:24'!
lf
	"Answer the Character representing a linefeed."

	^self value: 10! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 8/28/2013 10:25'!
lfCharacter
	"Answer the Character representing a linefeed."
	"Deprecated. To be removed soon. Please use #lf"

	^self lf! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'sma 3/11/2000 20:47'!
nbsp
	"non-breakable space."

	^ Character value: 202! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 8/28/2013 10:28'!
newLineCharacter
	"Answer the Character representing a newLine, that is, a linefeed.
	This should be the only method in the system that knows about this detail.
	Everybody else should eventually ask us."

	^self lf! !

!Character class methodsFor: 'accessing untypeable characters'!
newPage
	"Answer the Character representing a form feed."

	^self value: 12! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'jmv 4/11/2011 21:23'!
null
	"Answer the null Character."

	^self value: 0! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'NS 7/11/2000 09:20'!
pageDown
	^ self value: 12! !

!Character class methodsFor: 'accessing untypeable characters' stamp: 'NS 7/11/2000 09:21'!
pageUp
	^ self value: 11! !

!Character class methodsFor: 'accessing untypeable characters'!
space
	"Answer the Character representing a space."

	^self value: 32! !

!Character class methodsFor: 'accessing untypeable characters'!
tab
	"Answer the Character representing a tab."

	^self value: 9! !


!Character class methodsFor: 'constants'!
characterTable
	"Answer the class variable in which unique Characters are stored."

	^CharacterTable! !


!Character class methodsFor: 'converting' stamp: 'jmv 2/8/2013 08:32'!
evaluate: aBlock withUtf8BytesOfUnicodeCodePoint: aCodePoint
	"See senders for typical usage"

	| mask nBytes shift |
	aCodePoint < 128 ifTrue: [
		^aBlock value: aCodePoint ].
	nBytes _ aCodePoint highBit + 3 // 5.
	mask _ #(128 192 224 240 248 252 254 255) at: nBytes.
	shift _ nBytes - 1 * -6.
	aBlock value: (aCodePoint bitShift: shift) + mask.
	2 to: nBytes do: [ :i | 
		shift _ shift + 6.
		aBlock value: ((aCodePoint bitShift: shift) bitAnd: 63) + 128 ]! !

!Character class methodsFor: 'converting' stamp: 'jmv 10/7/2010 16:47'!
iso8859s15CodeForUnicodeCodePoint: codePoint
	"
	Answer nil if the Unicode codePoint is not a valid ISO 8859-15 character
	
	self assert: (Character iso8859s15CodeForUnicodeCodePoint: 16r41) = $A iso8859s15Code.
	self assert: (Character iso8859s15CodeForUnicodeCodePoint: 16r20AC) = $§ iso8859s15Code.
	"
	| code |
	code _ (UnicodeCodePoints indexOf: codePoint) -1.
	code = -1 ifTrue: [ ^nil ].
	^code! !

!Character class methodsFor: 'converting' stamp: 'jmv 8/31/2011 22:06'!
latin1ToMacRoman: charCode
	"Convert the receiver from ISO 8895-1 Latin-1 to MacRoman encoding."
	
	charCode < 128 ifTrue: [^ charCode].
	^ #[
		173 176 226 196 227 201 160 224 246 228 178 220 206 179 182 183	"80-8F"
		184 212 213 210 211 165 208 209 247 170 185 221 207 186 189 217	"90-9F"
		202 193 162 163 219 180 195 164 172 169 187 199 194 197 168 248	"A0-AF"
		161 177 198 215 171 181 166 225 252 218 188 200 222 223 240 192 	"B0-BF"
		203 231 229 204 128 129 174 130 233 131 230 232 237 234 235 236 	"C0-CF"
		245 132 241 238 239 205 133 249 175 244 242 243 134 250 251 167	"D0-DF"
		136 135 137 139 138 140 190 141 143 142 144 145 147 146 148 149	"E0-EF"
		253 150 152 151 153 155 154 214 191 157 156 158 159 254 255 216	"F0-FF"
	] at: charCode - 127! !

!Character class methodsFor: 'converting' stamp: 'jmv 8/31/2011 22:07'!
macRomanToLatin1: charCode
	"Convert the receiver from MacRoman to  ISO 8895-1 Latin-1 encoding"
	
	charCode < 128 ifTrue: [^ charCode].
	^ #[
		196 197 199 201 209 214 220 225 224 226 228 227 229 231 233 232 
		234 235 237 236 238 239 241 243 242 244 246 245 250 249 251 252 
		134 176 162 163 167 149 182 223 174 169 153 180 168 128 198 216 
		129 177 138 141 165 181 142 143 144 154 157 170 186 158 230 248 
		191 161 172 166 131 173 178 171 187 133 160 192 195 213 140 156 
		150 151 147 148 145 146 247 179 255 159 185 164 139 155 188 189 
		135 183 130 132 137 194 202 193 203 200 205 206 207 204 211 212 
		190 210 218 219 217 208 136 152 175 215 221 222 184 240 253 254
	] at: charCode - 127! !

!Character class methodsFor: 'converting' stamp: 'jmv 2/14/2013 14:32'!
nextUnicodeCodePointFromUtf8: anUtf8Stream
	"anUtf8Stream can be over a ByteArray
	Answer nil if conversion not possible, because of invalid UTF-8.
	Also answer nil for codePoint U+FEFF (BOM, unneededly added by Win clipboard)"

	| byte1 byte2 byte3 byte4 codePoint |
	byte1 _ anUtf8Stream next asInteger.
	byte1 < 128 ifTrue: [	"single byte"
		^byte1 ].
	
	"At least 2 bytes"
	byte2 _ anUtf8Stream next asInteger.
	(byte2 bitAnd: 16rC0) = 16r80 ifFalse: [^nil]. "invalid UTF-8"
	(byte1 bitAnd: 16rE0) = 192 ifTrue: [ "two bytes"
		^ ((byte1 bitAnd: 31) bitShift: 6) + (byte2 bitAnd: 63) ].
	
	"At least 3 bytes"
	byte3 _ anUtf8Stream next asInteger.
	(byte3 bitAnd: 16rC0) = 16r80 ifFalse: [^nil]. "invalid UTF-8"
	(byte1 bitAnd: 16rF0) = 224 ifTrue: [ "three bytes"
		codePoint _  ((byte1 bitAnd: 15) bitShift: 12) + ((byte2 bitAnd: 63) bitShift: 6) + (byte3 bitAnd: 63).
		^codePoint = 16rFEFF
			ifFalse: [ codePoint ]
			ifTrue: [ nil ]].

	"4 bytes"
	byte4 _ anUtf8Stream next asInteger.
	(byte4 bitAnd: 16rC0) = 16r80 ifFalse: [^nil]. "invalid UTF-8"
	(byte1 bitAnd: 16rF8) = 240 ifTrue: [  "four bytes"
		^((byte1 bitAnd: 16r7) bitShift: 18) + ((byte2 bitAnd: 63) bitShift: 12) + ((byte3 bitAnd: 63) bitShift: 6) + (byte4 bitAnd: 63) ].

	^nil! !

!Character class methodsFor: 'converting' stamp: 'jmv 2/8/2013 08:33'!
unicodeCodePointOfUtf8Bytes: aByteArray

	^ Character nextUnicodeCodePointFromUtf8: aByteArray readStream! !

!Character class methodsFor: 'converting' stamp: 'jmv 2/8/2013 08:34'!
utf8BytesOfUnicodeCodePoint: aCodePoint

	^ ByteArray streamContents: [ :strm |
		Character
			evaluate: [ :byte |
				strm nextPut: byte ]
			withUtf8BytesOfUnicodeCodePoint: aCodePoint ]! !


!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:28'!
aleph
	"
	Character aleph
	"
	^ self value: 16r8D! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:37'!
bullet
	"
	Character bullet
	"
	^ self value: 16r9F! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:23'!
complexNumbers
	"
	Character complexNumbers
	"
	^ self value: 16r86! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:32'!
contourIntegral
	"
	Character contourIntegral
	"
	^ self value: 16r93! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:30'!
directProduct
	"
	Character directProduct
	"
	^ self value: 16r8E! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:30'!
directSum
	"
	Character directSum
	"
	^ self value: 16r8F! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:38'!
dot
	"
	Character dot
	"
	^ self value: 16rB7! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:24'!
emptySet
	"
	Character emptySet
	"
	^ self value: 16r84! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:22'!
forAll
	"
	Character forAll
	"
	^ self value: 16r80! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:37'!
greaterNotEqual
	"
	Character greaterNotEqual
	"
	^ self value: 16r9D! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:35'!
greaterOrEqual
	"
	Character greaterOrEqual
	"
	^ self value: 16r99! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:36'!
greaterOverEqual
	"
	Character greaterOverEqual
	"
	^ self value: 16r9B! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:25'!
hamilton
	"
	Character hamilton
	"
	^ self value: 16r87! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:34'!
identical
	"
	Character identical
	"
	^ self value: 16r95! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:24'!
infinity
	"
	Character infinity
	"
	^ self value: 16r85! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:27'!
integerNumbers
	"
	Character integerNumbers
	"
	^ self value: 16r8C! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:31'!
integral
	"
	Character integral
	"
	^ self value: 16r92! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:36'!
lessNotEqual
	"
	Character lessNotEqual
	"
	^ self value: 16r9C! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:34'!
lessOrEqual
	"
	Character lessOrEqual
	"
	^ self value: 16r98! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:36'!
lessOverEqual
	"
	Character lessOverEqual
	"
	^ self value: 16r9A! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:26'!
naturalNumbers
	"
	Character naturalNumbers
	"
	^ self value: 16r88! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:34'!
notEqual
	"
	Character notEqual
	"
	^ self value: 16r94! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:34'!
notIdentical
	"
	Character notIdentical
	"
	^ self value: 16r96! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:22'!
partialDifferential
	"
	Character partialDifferential
	"
	^ self value: 16r81! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:26'!
primeNumbers
	"
	Character primeNumbers
	"
	^ self value: 16r89! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:26'!
rationalNumbers
	"
	Character rationalNumbers
	"
	^ self value: 16r8A! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:27'!
realNumbers
	"
	Character realNumbers
	"
	^ self value: 16r8B! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:37'!
ring
	"
	Character ring
	"
	^ self value: 16r9E! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:35'!
strictlyEquivalent
	"
	Character strictlyEquivalent
	"
	^ self value: 16r97! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:31'!
summation
	"
	Character summation
	"
	^ self value: 16r91! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:30'!
tensorProduct
	"
	Character tensorProduct
	"
	^ self value: 16r90! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:23'!
thereDoesNotExists
	"
	Character thereDoesNotExists
	"
	^ self value: 16r83! !

!Character class methodsFor: 'accessing mathematical symbols' stamp: 'jmv 12/1/2015 09:23'!
thereExists
	"
	Character thereExists
	"
	^ self value: 16r82! !


Character initialize!
