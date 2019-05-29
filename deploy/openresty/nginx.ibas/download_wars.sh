#!/bin/bash
	#设置参数变量
# 启动目录
STARTUP_FOLDER=`pwd`
# 工作目录默认第一个参数
WORK_FOLDER=$1
# 修正相对目录为启动目录
if [ "${WORK_FOLDER}" == "./" ]
 then
 WORK_FOLDER=${STARTUP_FOLDER}
 fi
 # 未提供工作目录，则取启动目录
if [ "${WORK_FOLDER}" == "" ]
 then
 WORK_FOLDER=${STARTUP_FOLDER}
 fi
#war包下载地址
IBAS_PACKAGE=$2
 if	 [ "${IBAS_PACKAGE}" == "" ];then 	 IBAS_PACKAGE=${WORK_FOLDER}/ibas_packages; fi;
if	 [ ! -e "${IBAS_PACKAGE}" ];then	 mkdir	 -p	 "${IBAS_PACKAGE}";	 fi;
 cd	 ${WORK_FOLDER}
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.root.service/201902281754/ibas.root.service-201902281754.war
echo ibas.root.service-201902281754.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.initialfantasy.service/201902261412/ibas.initialfantasy.service-201902261412.war
echo ibas.initialfantasy.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.integration.service/201902261412/ibas.integration.service-201902261412.war
echo ibas.integration.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.importexport.service/201902261412/ibas.importexport.service-201902261412.war
echo ibas.importexport.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.documents.service/201902261412/ibas.documents.service-201902261412.war
echo ibas.documents.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.approvalprocess.service/201902261412/ibas.approvalprocess.service-201902261412.war
echo ibas.approvalprocess.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.feedback.service/201902261412/ibas.feedback.service-201902261412.war
echo ibas.feedback.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.reportanalysis.service/201902261412/ibas.reportanalysis.service-201902261412.war
echo ibas.reportanalysis.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.accounting.service/201902261412/ibas.accounting.service-201902261412.war
echo ibas.accounting.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.materials.service/201902261412/ibas.materials.service-201902261412.war
echo ibas.materials.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.businesspartner.service/201902261412/ibas.businesspartner.service-201902261412.war
echo ibas.businesspartner.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.purchase.service/201902261412/ibas.purchase.service-201902261412.war
echo ibas.purchase.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.sales.service/201902261412/ibas.sales.service-201902261412.war
echo ibas.sales.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.receiptpayment.service/201902261412/ibas.receiptpayment.service-201902261412.war
echo ibas.receiptpayment.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.thirdpartyapp.service/201902261412/ibas.thirdpartyapp.service-201902261412.war
echo ibas.thirdpartyapp.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.barcode.service/201902261412/ibas.barcode.service-201902261412.war
echo ibas.barcode.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.commoditycenter.service/201903041035/ibas.commoditycenter.service-201903041035.war
echo ibas.commoditycenter.service-201903041035.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.channelmanagement.service/201902261412/ibas.channelmanagement.service-201902261412.war
echo ibas.channelmanagement.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.shoppingclient.service/201903041040/ibas.shoppingclient.service-201903041040.war
echo ibas.shoppingclient.service-201903041040.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.membercenter.service/201902261412/ibas.membercenter.service-201902261412.war
echo ibas.membercenter.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.wechatpay.service/201902261412/ibas.wechatpay.service-201902261412.war
echo ibas.wechatpay.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.marketingpromotion.service/201902261412/ibas.marketingpromotion.service-201902261412.war
echo ibas.marketingpromotion.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.message.service/201902261412/ibas.message.service-201902261412.war
echo ibas.message.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.projectsystem.service/201902261412/ibas.projectsystem.service-201902261412.war
echo ibas.projectsystem.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.alipay.service/201902261412/ibas.alipay.service-201902261412.war
echo ibas.alipay.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.youjia.service/201902261412/ibas.youjia.service-201902261412.war
echo ibas.youjia.service-201902261412.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.root.service/201903131105/ibas.root.service-201903131105.war
echo ibas.root.service-201903131105.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.initialfantasy.service/201903121212/ibas.initialfantasy.service-201903121212.war
echo ibas.initialfantasy.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.integration.service/201903121212/ibas.integration.service-201903121212.war
echo ibas.integration.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.importexport.service/201903121212/ibas.importexport.service-201903121212.war
echo ibas.importexport.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.documents.service/201903121212/ibas.documents.service-201903121212.war
echo ibas.documents.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.approvalprocess.service/201903121212/ibas.approvalprocess.service-201903121212.war
echo ibas.approvalprocess.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.feedback.service/201903121212/ibas.feedback.service-201903121212.war
echo ibas.feedback.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.reportanalysis.service/201903121212/ibas.reportanalysis.service-201903121212.war
echo ibas.reportanalysis.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.accounting.service/201903121212/ibas.accounting.service-201903121212.war
echo ibas.accounting.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.materials.service/201903121212/ibas.materials.service-201903121212.war
echo ibas.materials.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.businesspartner.service/201903121212/ibas.businesspartner.service-201903121212.war
echo ibas.businesspartner.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.purchase.service/201903121212/ibas.purchase.service-201903121212.war
echo ibas.purchase.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.sales.service/201903121212/ibas.sales.service-201903121212.war
echo ibas.sales.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.receiptpayment.service/201903121212/ibas.receiptpayment.service-201903121212.war
echo ibas.receiptpayment.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.thirdpartyapp.service/201903121212/ibas.thirdpartyapp.service-201903121212.war
echo ibas.thirdpartyapp.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.barcode.service/201903121212/ibas.barcode.service-201903121212.war
echo ibas.barcode.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.commoditycenter.service/201903121212/ibas.commoditycenter.service-201903121212.war
echo ibas.commoditycenter.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.channelmanagement.service/201903121212/ibas.channelmanagement.service-201903121212.war
echo ibas.channelmanagement.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.shoppingclient.service/201903131105/ibas.shoppingclient.service-201903131105.war
echo ibas.shoppingclient.service-201903131105.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.membercenter.service/201903121212/ibas.membercenter.service-201903121212.war
echo ibas.membercenter.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.wechatpay.service/201903121212/ibas.wechatpay.service-201903121212.war
echo ibas.wechatpay.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.marketingpromotion.service/201903121212/ibas.marketingpromotion.service-201903121212.war
echo ibas.marketingpromotion.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.message.service/201903121212/ibas.message.service-201903121212.war
echo ibas.message.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.projectsystem.service/201903121212/ibas.projectsystem.service-201903121212.war
echo ibas.projectsystem.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.alipay.service/201903121212/ibas.alipay.service-201903121212.war
echo ibas.alipay.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
wget	 -q	 -P	 ${IBAS_PACKAGE}	http://nexus.avacloud.com.cn/repository/maven-releases/org/colorcoding/apps/ibas.youjia.service/201903121212/ibas.youjia.service-201903121212.war
echo ibas.youjia.service-201903121212.war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
# 程序输出覆盖 结束
chmod	 -R		 777	 ${IBAS_PACKAGE}
echo	 --下载war包完成