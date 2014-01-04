<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>
<jsp:useBean id="model" type="org.unidal.maven.plugin.uml.UmlViewModel" scope="request" />

<a:layout>

	<br>

	<form action="${model.webapp}/uml">
		<table>
			<tr>
				<td colspan="3" nowrap>
					<select id="file" name="file" style="width: 100%">
						<option value="">--- Select File ---</option>
						${w:showOptions(model.umlFiles, model.umlFile, 'path', 'path')}
					</select>
					<c:if test="${not empty model.umlFile}"><a href="${model.webapp}/uml/${model.umlFile}" target="_blank">Get Link</a></c:if>
				</td>
			</tr>
			<c:if test="${not empty model.message}">
				<tr>
					<td colspan="3">
						<c:choose>
							<c:when test="${model.error}"><span class="text-error">${model.message}</span></c:when>
							<c:otherwise><span class="text-success">${model.message}</span></c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:if>
			<tr>
				<td><textarea id="uml" name="uml" style="height: 480px; width: 320px">${w:htmlEncode(model.uml)}</textarea></td>
				<td width="10"></td>
				<td valign="top"><span id="svg">${model.svg}</span></td>
			</tr>
			<tr>
				<td colspan="3">
					<button type="submit" name="update" class="btn btn-medium btn-primary">Update</button>
				</td>
			</tr>
		</table>
	</form>

	<script lang="javascript">
	var interval = 500;
	var dirty = false;
	var changed = false;
	
	function refresh() {
		var uml = $("#uml").val();
		
		if (changed) {
		   $.ajax({
			  url: '${model.webapp}/uml',
			  type: 'POST',
			  data: 'type=text&uml=' + encodeURIComponent(uml),
			  async: false,
			  success: function(data) {
				// called when successful
				$('#svg').html(data);
			  },
			  error: function(e) {
				// called when there is an error
				// console.log(e.message);
			  }
			});
		    changed = false;
		}
		
		setTimeout(refresh, interval);
	}
	
	$(document).ready(function () {
		$('#uml').bind('input propertychange', function() {
			changed = true;
			dirty = true;
		});
		
		$('#file').change(function() {
			var file = $(this).children('option:selected').val();
			
			window.location.href="?file=" + encodeURIComponent(file);
		});
		
	    $(function(){setTimeout(refresh, interval);});
	});
	</script>
</a:layout>