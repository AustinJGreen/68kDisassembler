WOAH		RTS

			ORG			$7000

.BEFORE:	NOP

			BGT			.BEFORE
			BGT			.END
			BLE			.END
			BRA			.END
			BLT			.END
			BEQ.B     	.END	
   			BGT.B     	.END
    		BGT.B     	.END
    		BLE.B     	.END
    		BGT.B     	.END
    		BLE.B     	.END
    		BRA.B		.END
    		BEQ.W     	.END
    		BRA.W		.END
    		BGT.W		.BEFORE
			BEQ			.BEFORE
			BLE			.BEFORE
			BGT			WOAH
			BRA			WOAH
			BLE			WOAH
			BLT			WOAH
			
.END		NOP











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
