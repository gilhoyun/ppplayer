<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<section class="px-64 py-5">
	<div class="grid grid-cols-4 gap-10 text-center">
		<!-- 팀리그 -->
		<a href="${pageContext.request.contextPath}/usr/team/reservation"
			class="flex flex-col items-center transition">
			<div>
				<img src="https://j.gifs.com/pZ9zQX.gif" alt="팀리그"
					class="h-16 w-16 object-cover rounded-lg">
			</div>
			<p>구장 예약</p>
		</a>

		<!-- 팀원 모집 -->
		<a href="${pageContext.request.contextPath}/usr/team/rankings"
			class="flex flex-col items-center transition">
			<div>
				<img src="https://j.gifs.com/K8A6Zl.gif" alt="팀원 모집"
					class="h-16 w-16 object-cover rounded-lg">
			</div>
			<p>팀 리그</p>
		</a>

		<!-- 게스트 모집 -->
		<a href="${pageContext.request.contextPath}/usr/team/teamList"
			class="flex flex-col items-center transition">
			<div>
				<img src="https://j.gifs.com/Z8ZWV2.gif" alt="게스트 모집"
					class="h-16 w-16 object-cover rounded-lg">
			</div>
			<p>팀 찾기</p>
		</a>

		<!-- 팀 만들기 -->
		<a href="${pageContext.request.contextPath}/team/create"
			class="flex flex-col items-center transition">
			<div>
				<img src="https://j.gifs.com/46W9Rg.gif" alt="팀 만들기"
					class="h-16 w-16 object-cover rounded-lg">
			</div>
			<p>팀 매칭</p>
		</a>
	</div>
</section>
<div class="bg-gray-100 py-5">
	<section class="px-10 py-5">
		<!-- 배너 이미지 추가 -->
		<div class="relative">
			<img
				src="https://d31wz4d3hgve8q.cloudfront.net/media/banner-6member_pc.png"
				alt="배너 이미지"
				class="w-full max-w-6xl h-72 mx-auto object-cover rounded-lg shadow-lg">
		</div>
	</section>
</div>






<section class="py-8">
	<div
		class="max-w-6xl mx-auto p-6 bg-white rounded-lg shadow-md relative">


		<!-- Error message section -->
		<c:if test="${not empty errorMessage}">
			<div
				class="alert alert-error mb-6 p-4 bg-red-100 text-red-700 rounded-lg">
				${errorMessage}</div>
		</c:if>

		<!-- Reservations section -->
		<c:choose>
			<c:when test="${not empty reservations}">
				<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
					<c:forEach var="reservation" items="${reservations}">
						<div
							class="card w-full bg-white shadow-xl rounded-lg overflow-hidden transform transition-transform duration-300 hover:scale-105 flex flex-col">
							<figure class="px-6 pt-6 flex-grow relative">
								<img src="${reservation.imgUrl}" alt="풋살장 이미지"
									class="rounded-xl h-48 w-full object-cover"
									style="object-fit: cover; height: 200px; margin-top: -20px;" />

								<!-- Overlay section with payment method and service status as buttons -->
								<div class="absolute top-4 right-4 space-x-2">
									<span
										class="px-4 py-2 text-sm text-white bg-orange-500 rounded-full">${reservation.paymentMethod}</span>
									<span
										class="px-4 py-2 text-sm text-white bg-green-500 rounded-full">${reservation.serviceStatus}</span>
								</div>
							</figure>
							<div
								class="card-body p-6 text-center flex-grow flex flex-col justify-between">
								<div class="flex items-center justify-between">
									<h2 class="card-title text-md font-semibold text-gray-800 mb-4">${reservation.placeName}</h2>
								</div>
								<div class="text-left mb-4">
									<p class="text-sm text-gray-600 mb-2">
										<i class="fa-solid fa-head-side-virus"></i> <strong>이용
											대상 :</strong> ${reservation.useTgtInfo}
									</p>
									<p class="text-sm text-gray-600 mb-2">
										<i class="fa-solid fa-calendar-check"></i> <strong>접수
											시작 :</strong> ${reservation.startDate.substring(2,16)}
									</p>
									<p class="text-sm text-gray-600 mb-2">
										<i class="fa-solid fa-calendar-check"></i> <strong>접수
											종료 :</strong> ${reservation.endDate.substring(2,16)}
									</p>
									<p class="text-sm text-gray-600 mb-4">
										<i class="fa-solid fa-hourglass-half"></i> <strong>이용
											시간 :</strong> ${reservation.startTime} - ${reservation.endTime}
									</p>
								</div>
								<a href="${reservation.url}" target="_blank"
									class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">바로가기</a>
							</div>
						</div>
					</c:forEach>
				</div>

				<!-- Pagination section -->
				<div class="mt-5 flex justify-between items-center">
					<div class="flex-grow flex justify-center">
						<div class="join">
							<c:set var="path"
								value="?boardId=${board.id}&searchType=${searchType}&searchKeyword=${searchKeyword}" />

							<c:if test="${fromPage != 1}">
								<a href="${path}&page=1" class="join-item btn"><<</a>
								<a href="${path}&page=${fromPage - 1}" class="join-item btn"><</a>
							</c:if>

							<c:forEach var="i" begin="${fromPage}" end="${toPage}">
								<a href="${path}&page=${i}"
									class="join-item btn btn-square ${page == i ? 'btn-active' : ''}">
									${i} </a>
							</c:forEach>

							<c:if test="${toPage != totalPages}">
								<a href="${path}&page=${toPage + 1}" class="join-item btn">></a>
								<a href="${path}&page=${totalPages}" class="join-item btn">>></a>
							</c:if>
						</div>
					</div>
				</div>
			</c:when>
			<c:otherwise>
				<div class="text-center text-lg font-semibold text-gray-500">
					<p>현재 예약 가능한 풋살장이 없습니다.</p>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</section>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
