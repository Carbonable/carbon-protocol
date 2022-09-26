



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor




  
{% tabs %}  
{% tab title="Implicit args_79" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_80" %}

```cairo
name(felt)
symbol(felt)
owner(felt)
```  
{% endtab %}  
{% tab title="Returns_81" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## totalSupply




  
{% tabs %}  
{% tab title="Implicit args_82" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_83" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_84" %}

```cairo
totalSupply(Uint256)
```  
{% endtab %}  
{% endtabs %}


## tokenByIndex




  
{% tabs %}  
{% tab title="Implicit args_85" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_86" %}

```cairo
index(Uint256)
```  
{% endtab %}  
{% tab title="Returns_87" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% endtabs %}


## tokenOfOwnerByIndex




  
{% tabs %}  
{% tab title="Implicit args_88" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_89" %}

```cairo
owner(felt)
index(Uint256)
```  
{% endtab %}  
{% tab title="Returns_90" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% endtabs %}


## supportsInterface




  
{% tabs %}  
{% tab title="Implicit args_91" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_92" %}

```cairo
interfaceId(felt)
```  
{% endtab %}  
{% tab title="Returns_93" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}


## name




  
{% tabs %}  
{% tab title="Implicit args_94" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_95" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_96" %}

```cairo
name(felt)
```  
{% endtab %}  
{% endtabs %}


## symbol




  
{% tabs %}  
{% tab title="Implicit args_97" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_98" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_99" %}

```cairo
symbol(felt)
```  
{% endtab %}  
{% endtabs %}


## balanceOf




  
{% tabs %}  
{% tab title="Implicit args_100" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_101" %}

```cairo
owner(felt)
```  
{% endtab %}  
{% tab title="Returns_102" %}

```cairo
balance(Uint256)
```  
{% endtab %}  
{% endtabs %}


## ownerOf




  
{% tabs %}  
{% tab title="Implicit args_103" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_104" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_105" %}

```cairo
owner(felt)
```  
{% endtab %}  
{% endtabs %}


## getApproved




  
{% tabs %}  
{% tab title="Implicit args_106" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_107" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_108" %}

```cairo
approved(felt)
```  
{% endtab %}  
{% endtabs %}


## isApprovedForAll




  
{% tabs %}  
{% tab title="Implicit args_109" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_110" %}

```cairo
owner(felt)
operator(felt)
```  
{% endtab %}  
{% tab title="Returns_111" %}

```cairo
isApproved(felt)
```  
{% endtab %}  
{% endtabs %}


## tokenURI




  
{% tabs %}  
{% tab title="Implicit args_112" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_113" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_114" %}

```cairo
tokenURI(felt)
```  
{% endtab %}  
{% endtabs %}


## owner




  
{% tabs %}  
{% tab title="Implicit args_115" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_116" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_117" %}

```cairo
owner(felt)
```  
{% endtab %}  
{% endtabs %}


## image_url




  
{% tabs %}  
{% tab title="Implicit args_118" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_119" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_120" %}

```cairo
image_url_len(felt)
image_url(felt)
```  
{% endtab %}  
{% endtabs %}


## image_data




  
{% tabs %}  
{% tab title="Implicit args_121" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_122" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_123" %}

```cairo
image_data_len(felt)
image_data(felt)
```  
{% endtab %}  
{% endtabs %}


## external_url




  
{% tabs %}  
{% tab title="Implicit args_124" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_125" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_126" %}

```cairo
external_url_len(felt)
external_url(felt)
```  
{% endtab %}  
{% endtabs %}


## description




  
{% tabs %}  
{% tab title="Implicit args_127" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_128" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_129" %}

```cairo
description_len(felt)
description(felt)
```  
{% endtab %}  
{% endtabs %}


## holder




  
{% tabs %}  
{% tab title="Implicit args_130" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_131" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_132" %}

```cairo
holder_len(felt)
holder(felt)
```  
{% endtab %}  
{% endtabs %}


## certifier




  
{% tabs %}  
{% tab title="Implicit args_133" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_134" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_135" %}

```cairo
certifier_len(felt)
certifier(felt)
```  
{% endtab %}  
{% endtabs %}


## land




  
{% tabs %}  
{% tab title="Implicit args_136" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_137" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_138" %}

```cairo
land_len(felt)
land(felt)
```  
{% endtab %}  
{% endtabs %}


## unit_land_surface




  
{% tabs %}  
{% tab title="Implicit args_139" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_140" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_141" %}

```cairo
unit_land_surface_len(felt)
unit_land_surface(felt)
```  
{% endtab %}  
{% endtabs %}


## country




  
{% tabs %}  
{% tab title="Implicit args_142" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_143" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_144" %}

```cairo
country_len(felt)
country(felt)
```  
{% endtab %}  
{% endtabs %}


## expiration




  
{% tabs %}  
{% tab title="Implicit args_145" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_146" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_147" %}

```cairo
expiration_len(felt)
expiration(felt)
```  
{% endtab %}  
{% endtabs %}


## total_co2_sequestration




  
{% tabs %}  
{% tab title="Implicit args_148" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_149" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_150" %}

```cairo
total_co2_sequestration_len(felt)
total_co2_sequestration(felt)
```  
{% endtab %}  
{% endtabs %}


## unit_co2_sequestration




  
{% tabs %}  
{% tab title="Implicit args_151" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_152" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_153" %}

```cairo
unit_co2_sequestration_len(felt)
unit_co2_sequestration(felt)
```  
{% endtab %}  
{% endtabs %}


## sequestration_color




  
{% tabs %}  
{% tab title="Implicit args_154" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_155" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_156" %}

```cairo
sequestration_color_len(felt)
sequestration_color(felt)
```  
{% endtab %}  
{% endtabs %}


## sequestration_type




  
{% tabs %}  
{% tab title="Implicit args_157" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_158" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_159" %}

```cairo
sequestration_type_len(felt)
sequestration_type(felt)
```  
{% endtab %}  
{% endtabs %}


## sequestration_category




  
{% tabs %}  
{% tab title="Implicit args_160" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_161" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_162" %}

```cairo
sequestration_category_len(felt)
sequestration_category(felt)
```  
{% endtab %}  
{% endtabs %}


## background_color




  
{% tabs %}  
{% tab title="Implicit args_163" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_164" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_165" %}

```cairo
background_color_len(felt)
background_color(felt)
```  
{% endtab %}  
{% endtabs %}


## animation_url




  
{% tabs %}  
{% tab title="Implicit args_166" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_167" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_168" %}

```cairo
animation_url_len(felt)
animation_url(felt)
```  
{% endtab %}  
{% endtabs %}


## youtube_url




  
{% tabs %}  
{% tab title="Implicit args_169" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_170" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_171" %}

```cairo
youtube_url_len(felt)
youtube_url(felt)
```  
{% endtab %}  
{% endtabs %}


## approve




  
{% tabs %}  
{% tab title="Implicit args_172" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_173" %}

```cairo
to(felt)
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_174" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setApprovalForAll




  
{% tabs %}  
{% tab title="Implicit args_175" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_176" %}

```cairo
operator(felt)
approved(felt)
```  
{% endtab %}  
{% tab title="Returns_177" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## transferFrom




  
{% tabs %}  
{% tab title="Implicit args_178" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_179" %}

```cairo
from_(felt)
to(felt)
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_180" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## safeTransferFrom




  
{% tabs %}  
{% tab title="Implicit args_181" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_182" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_183" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## mint




  
{% tabs %}  
{% tab title="Implicit args_184" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_185" %}

```cairo
to(felt)
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_186" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## burn




  
{% tabs %}  
{% tab title="Implicit args_187" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_188" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns_189" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setTokenURI




  
{% tabs %}  
{% tab title="Implicit args_190" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_191" %}

```cairo
tokenId(Uint256)
tokenURI(felt)
```  
{% endtab %}  
{% tab title="Returns_192" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## transferOwnership




  
{% tabs %}  
{% tab title="Implicit args_193" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_194" %}

```cairo
newOwner(felt)
```  
{% endtab %}  
{% tab title="Returns_195" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## renounceOwnership




  
{% tabs %}  
{% tab title="Implicit args_196" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_197" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_198" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_image_url




  
{% tabs %}  
{% tab title="Implicit args_199" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_200" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_201" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_image_data




  
{% tabs %}  
{% tab title="Implicit args_202" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_203" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_204" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_external_url




  
{% tabs %}  
{% tab title="Implicit args_205" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_206" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_207" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_description




  
{% tabs %}  
{% tab title="Implicit args_208" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_209" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_210" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_holder




  
{% tabs %}  
{% tab title="Implicit args_211" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_212" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_213" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_certifier




  
{% tabs %}  
{% tab title="Implicit args_214" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_215" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_216" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_land




  
{% tabs %}  
{% tab title="Implicit args_217" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_218" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_219" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_unit_land_surface




  
{% tabs %}  
{% tab title="Implicit args_220" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_221" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_222" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_country




  
{% tabs %}  
{% tab title="Implicit args_223" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_224" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_225" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_expiration




  
{% tabs %}  
{% tab title="Implicit args_226" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_227" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_228" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_total_co2_sequestration




  
{% tabs %}  
{% tab title="Implicit args_229" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_230" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_231" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_unit_co2_sequestration




  
{% tabs %}  
{% tab title="Implicit args_232" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_233" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_234" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_sequestration_color




  
{% tabs %}  
{% tab title="Implicit args_235" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_236" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_237" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_sequestration_type




  
{% tabs %}  
{% tab title="Implicit args_238" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_239" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_240" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_sequestration_category




  
{% tabs %}  
{% tab title="Implicit args_241" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_242" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_243" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_background_color




  
{% tabs %}  
{% tab title="Implicit args_244" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_245" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_246" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_animation_url




  
{% tabs %}  
{% tab title="Implicit args_247" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_248" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_249" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_youtube_url




  
{% tabs %}  
{% tab title="Implicit args_250" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_251" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_252" %}

```cairo

```  
{% endtab %}  
{% endtabs %}

