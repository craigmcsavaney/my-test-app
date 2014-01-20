module StaticPagesHelper

	def faq(question,answer)
    	"<div class='collapse-group question-group row'>
      		<div class='span1'><i class='fa fa-plus-square fa-2x'></i></div>
      		<div class='span8'>
        		<a class='question'>#{question}</a>
        		<div class='collapse answer'>#{answer}</div>
      		</div>
    	</div>".html_safe
  	end

  	def webform_url
    	"http://www.hydrapouch.com/causebutton/crm/modules/Webforms/capture.php"
  	end

end
