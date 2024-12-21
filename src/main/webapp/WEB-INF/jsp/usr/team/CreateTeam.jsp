<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="회원가입" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
	let validLoginId = null;

	const teamJoinForm_onSubmit = function(form) {
		form.teamName.value = form.teamName.value.trim();
		form.region.value = form.region.value.trim();
		form.slogan.value = form.slogan.value.trim();
		form.teamImage.value = form.teamImage.value.trim();
		
		if (!form.teamName.value) {
			alert('팀이름을 입력해주세요.');
			form.teamName.focus();
			return false;
		}
		
		if (!form.region.value) {
			alert('지역을 입력해주세요.');
			form.region.focus();
			return false;
		}
		
		if (!form.slogan.value) {
			alert('슬로건을 입력해주세요.');
			form.slogan.focus();
			return false;
		}

		if (!form.teamImage.value) {
			alert('팀 사진을 업로드해주세요.');
			form.teamImage.focus();
			return false;
		}

		return true;
	};

	const teamDupChk = function(el) {
		el.value = el.value.trim();

		let teaemDupChkMsg = $('#teaemDupChkMsg');

		if (!el.value) {
			teaemDupChkMsg.removeClass('text-green-500');
			teaemDupChkMsg.addClass('text-red-500');
			teaemDupChkMsg.html(`<span>팀이름은 필수 입력 정보입니다</span>`);
			return;
		}

		$.ajax({
			url: '/usr/team/teamDupChk',
			type: 'GET',
			data: { teamName: el.value },
			dataType: 'json',
			success: function(data) {
				if (data.success) {
					teamDupChk.removeClass('text-red-500');
					teamDupChk.addClass('text-green-500');
					teamDupChk.html(`<span>${data.resultMsg}</span>`);
					validTeamName = el.value;
				} else {
					teaemDupChkMsg.removeClass('text-green-500');
					teaemDupChkMsg.addClass('text-red-500');
					teaemDupChkMsg.html(`<span>${data.resultMsg}</span>`);
					validTeamName = null;
				}
			},
			error: function(xhr, status, error) {
				console.log('Error: ' + error);
			},
		});
	};
</script>

<section class="px-auto py-8">
	<div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<form action="doCreateTeam" method="post" enctype="multipart/form-data" onsubmit="return teamJoinForm_onSubmit(this);">
			<div class="table-box">
				<table class="w-full text-left border-collapse">
					<thead>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">팀 이름</th>
							<td class="py-2 px-4">
								<input name="teamName" type="text" class="border p-2 rounded w-full" placeholder="팀 이름을 입력해주세요." onblur="teamDupChk(this)" />
								<div id="teaemDupChkMsg" style="margin-top: 4px; font-size: 0.875rem;"></div>
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">지역</th>
							<td class="py-2 px-4">
								<input name="region" type="text" class="border p-2 rounded w-full" placeholder="지역을 입력해주세요." />
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">슬로건</th>
							<td class="py-2 px-4">
								<input name="slogan" type=text class="border p-2 rounded w-full" placeholder="슬로건을 입력해주세요." />
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">팀 사진</th>
							<td class="py-2 px-4">
								<input name="teamImage" type="file" accept="image/*" class="border p-2 rounded w-full" />
							</td>
						</tr>
					</thead>
				</table>
			</div>
			<div class="text-right mt-4">
				<button type="submit" class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">창단</button>
			</div>
		</form>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
