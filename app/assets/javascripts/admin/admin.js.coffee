select2 = ->
  $(".select2").select2({
    placeholder: $(this).attr("placeholder")
  });

window.select2 = select2

generate_url =(id_source, id_url) ->
  text = $("#"+id_source).val().replace(/^\s*|\s*$/g,"")
  text=text.replace("°","")
  if ($("#"+id_url).val()=='')
    $("#"+id_url).val(seourl(text))

seourl = (title)->
  text=title.replace(/^\s*|\s*$/g,"")
  s='';
  a1="QWERTYUIOPASDFGHJKLZXCVBNM ,.;'éěÉĚřŘťŤžŽúÚůŮüÜíÍóÓáÁšŠďĎýÝčČňŇäÄĺĹľĽŕŔöÖ/"+'"';
  a2="qwertyuiopasdfghjklzxcvbnm-----eeeerrttzzuuuuuuiiooaassddyyccnnaallllrroo-"+'-';
  y="";
  i=0
  while i< text.length
    z=text[i]
    i++
    k=0
    while k < a1.length
      if (z==a1[k])
        z=a2[k]
        k=a1.length
      k++
    if (!(y=='-' && z=='-'))
      s+=z
    y=z
  s

gen_url = ->
  $("#category_title").change ->
    generate_url("category_title","category_url")
  $("#page_title").change ->
    generate_url("page_title","page_url")
sortable = ->
  $(".menu-position").sortable({ update: (event, ui) ->
    result = $(this).sortable( "serialize" )+'&d=param_reorder'
    #console.log(result)
    $.post({data:result, url: $(this).attr("data-url")});
  });

window.sortable = sortable

close_banner_image = (id)->
  $(".destroy-banner-image[data-id='"+id+"']").click ->
    id = $(this).data("id")
    #console.log(id)
    $("#file-"+id).remove()
    $("#title-"+id).remove()
    $("#ms-"+id).remove()
    $("#position-"+id).remove()
    $(this).remove()

window.close_banner_image = close_banner_image

$(document).ready ->
  select2()
  gen_url()
  sortable()
